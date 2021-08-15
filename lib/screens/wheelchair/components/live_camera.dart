import 'dart:async';
import 'dart:ui' as ui;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/location_controller.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/coordinate.dart';
import 'package:sws_web/models/location.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class _Item {
  String wheelchairID;
  String plate;
  Offset center;
  List<Offset> offsets;

  _Item({this.plate, this.center, this.offsets});
}

class _Vertice {
  int x;
  int y;

  _Vertice({this.x, this.y});
}

class LiveCamera extends StatefulWidget {
  final WebSocketChannel channel;
  final bool position;
  LiveCamera({Key key, @required this.channel, this.position = false})
      : super(key: key);

  @override
  _LiveCameraState createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  WheelchairController wheelchairController;
  LocationController locationController;
  OverlayEntry sticky;
  GlobalKey stickyKey = GlobalKey();

  @override
  void initState() {
    if (sticky != null) {
      sticky.remove();
    }

    SchedulerBinding.instance.addPostFrameCallback((_) {
      Overlay.of(context).insert(sticky);
    });

    super.initState();
    // IOWebSocketChannel.connect('');
  }

  @override
  void dispose() {
    sticky.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    locationController = LocationController(firestoreService: firestoreService);
    wheelchairController =
        WheelchairController(firestoreService: firestoreService);

    double _height = 480;
    double _width = 640;
    // List<List<Offset>> offsets = <List<Offset>>[];
    // List<Offset> _centers = <Offset>[];
    // List<String> plates = <String>[];
    List<_Item> items = <_Item>[];

    return Column(
      children: [
        StreamBuilder(
          stream: widget.channel.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Loading();
            return Container(
              height: _height,
              width: double.infinity,
              decoration: BoxDecoration(color: kSecondaryColor),
              child: Stack(
                children: [
                  Center(
                    child: Container(
                      height: _height,
                      width: _width,
                      child: Image.memory(
                        snapshot.data,
                        key: stickyKey,
                        fit: BoxFit.contain,
                        gaplessPlayback: true,
                      ),
                    ),
                  ),
                  widget.position
                      ? Center(
                          child: Container(
                            height: _height,
                            width: _width,
                            child: StreamBuilder(
                              stream: locationController.liveLocationStream(),
                              builder: (context, snapshot) {
                                items.clear();

                                if (!snapshot.hasData) return Loading();
                                List snapshots =
                                    snapshot.data.documents.toList();
                                Location data;

                                if (snapshots.length > 0) {
                                  data = Location.fromSnapShot(snapshots[0]);
                                  if (data.data.length > 0) {
                                    data.data.forEach((e) {
                                      items.add(processDataVision(e));
                                      // items.add(processDataTesseract(e));
                                    });
                                  }
                                }

                                return CustomPaint(
                                  painter: ItemPainter(items: items),
                                );
                              },
                            ),
                          ),
                        )
                      : Container(),
                  widget.position
                      ? Center(
                          child: Container(
                            height: _height,
                            width: _width,
                            child: CustomPaint(
                              painter: CenterPainter(items: items),
                            ),
                          ),
                        )
                      : Container(),
                  // Center(
                  //   child: Container(
                  //     height: _height,
                  //     width: _width,
                  //     child: CustomPaint(
                  //       painter: RefPainter(offsets: [
                  //         Offset(63, 201),
                  //         Offset(467, 211),
                  //       ]),
                  //     ),
                  //   ),
                  // ),
                  widget.position
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            height: _height,
                            width: 200,
                            child: ListView.builder(
                                itemCount: items.length,
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                itemBuilder: (context, index) {
                                  _Item item = items[index];
                                  return Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Plate: ${item.plate}',
                                        color: Colors.white,
                                      ),
                                      CustomText(
                                        text:
                                            'center: (${item.center.dx}, ${item.center.dy})',
                                        color: Colors.white,
                                      ),
                                      CustomText(
                                        text:
                                            'Location: ${generateLocation(item.center)}',
                                        color: Colors.white,
                                      )
                                    ],
                                  );
                                }),
                          ),
                        )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  processDataVision(e) {
    var bbox = e['boundingPoly']['vertices'];
    List<_Vertice> vertices = [];
    bbox.forEach((point) {
      vertices.add(_Vertice(x: point['x'], y: point['y']));
    });
    final keyContext = stickyKey.currentContext;
    List<Offset> _offsets = <Offset>[];
    _Item _item = new _Item();

    if (keyContext != null) {
      // plates.add(e['description']);

      _item.wheelchairID = e['wheelchairID'];
      _item.plate = e['plate'];
      final box = keyContext.findRenderObject() as RenderBox;
      // Original size 320 x 240
      // final pos = box.localToGlobal(Offset.zero);
      // print(pos);
      Size size = box.size;
      double scale = size.width / 320;
      print('SCALE: $scale');
      vertices.forEach((point) {
        _offsets.add(Offset(point.x * scale, point.y * scale));
      });
      if (_offsets.length == 4) {
        _offsets.add(Offset(vertices[0].x * scale, vertices[0].y * scale));

        Offset ref1 = _offsets[1];
        Offset ref2 = _offsets[3];
        double x = (ref1.dx + ref2.dx) / 2;
        double y = (ref1.dy + ref2.dy) / 2;
        // _centers.add(Offset(x, y));
        _item.center = Offset(x, y);
      }
      // offsets.add(_offsets);
      _item.offsets = _offsets;
    }
    return _item;
  }

  processDataTesseract(e) {
    var bbox = e['bbox'];
    List<_Vertice> vertices = [];
    vertices.add(_Vertice(x: bbox['x0'], y: bbox['y0']));
    vertices.add(_Vertice(x: bbox['x0'], y: bbox['y1']));
    vertices.add(_Vertice(x: bbox['x1'], y: bbox['y1']));
    vertices.add(_Vertice(x: bbox['x1'], y: bbox['y0']));
    final keyContext = stickyKey.currentContext;
    List<Offset> _offsets = <Offset>[];
    _Item _item = new _Item();

    if (keyContext != null) {
      // plates.add(e['description']);

      _item.wheelchairID = e['wheelchairID'];
      _item.plate = e['plate'];
      final box = keyContext.findRenderObject() as RenderBox;
      // Original size 320 x 240
      // final pos = box.localToGlobal(Offset.zero);
      // print(pos);
      Size size = box.size;
      double scale = size.width / 320;
      print('SCALE: $scale');
      vertices.forEach((point) {
        _offsets.add(Offset(point.x * scale, point.y * scale));
      });
      if (_offsets.length == 4) {
        _offsets.add(Offset(vertices[0].x * scale, vertices[0].y * scale));

        Offset ref1 = _offsets[1];
        Offset ref2 = _offsets[3];
        double x = (ref1.dx + ref2.dx) / 2;
        double y = (ref1.dy + ref2.dy) / 2;
        // _centers.add(Offset(x, y));
        _item.center = Offset(x, y);
      }
      // offsets.add(_offsets);
      _item.offsets = _offsets;
    }
    return _item;
  }

  String generateLocation(Offset param) {
    if (param.dy < 160) {
      // top row
      if (param.dx > 220) return ROOMS['WR'];
      if (param.dx < 170) return ROOMS['R'];
    } else if (param.dy > 325) {
      // bottom row
      if (param.dx >= 300) return ROOMS['CR3'];
      if (param.dx < 300) return ROOMS['X'];
    } else {
      // center row aka corridor
      return ROOMS['C'];
    }
    return '';
  }
}

class RefPainter extends CustomPainter {
  final List<Offset> offsets;
  RefPainter({@required this.offsets});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = Colors.deepOrange
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    canvas.drawPoints(pointMode, offsets, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class ItemPainter extends CustomPainter {
  final List<_Item> items;
  ItemPainter({@required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    items.forEach((e) => canvas.drawPoints(pointMode, e.offsets, paint));
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class CenterPainter extends CustomPainter {
  final List<_Item> items;
  CenterPainter({@required this.items});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.points;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    List<Offset> offsets = <Offset>[];
    items.forEach((element) => offsets.add(element.center));

    canvas.drawPoints(pointMode, offsets, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
