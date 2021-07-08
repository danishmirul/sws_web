import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/location_controller.dart';
import 'package:sws_web/models/location.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveCamera extends StatefulWidget {
  final WebSocketChannel channel;
  LiveCamera({Key key, @required this.channel}) : super(key: key);

  @override
  _LiveCameraState createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
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
    LocationController locationController =
        LocationController(firestoreService: firestoreService);

    double _height = 480;
    double _width = 640;

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
                  Center(
                    child: Container(
                      height: _height,
                      width: _width,
                      child: StreamBuilder(
                        stream: locationController.liveLocationStream(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Loading();
                          List snapshots = snapshot.data.documents.toList();
                          Location data;
                          List<Offset> offsets = <Offset>[];

                          if (snapshots.length > 0) {
                            data = Location.fromSnapShot(snapshots[0]);
                            data.data.forEach((e) {
                              List vertices = e['boundingPoly']['vertices'];
                              final keyContext = stickyKey.currentContext;

                              if (keyContext != null) {
                                final box =
                                    keyContext.findRenderObject() as RenderBox;
                                // Original size 320 x 240
                                // final pos = box.localToGlobal(Offset.zero);
                                // print(pos);
                                Size size = box.size;
                                double scale = size.width / 320;
                                vertices.forEach((point) {
                                  offsets.add(Offset(
                                      point['x'] * scale, point['y'] * scale));
                                });
                                if (offsets.length == 4) {
                                  offsets.add(Offset(vertices[0]['x'] * scale,
                                      vertices[0]['y'] * scale));
                                }
                              }
                            });
                          }

                          return CustomPaint(
                            painter: MyPainter(offsets: offsets),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class MyPainter extends CustomPainter {
  final List<Offset> offsets;
  MyPainter({@required this.offsets});

  @override
  void paint(Canvas canvas, Size size) {
    final pointMode = ui.PointMode.polygon;
    final paint = Paint()
      ..color = Colors.red
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPoints(pointMode, offsets, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
