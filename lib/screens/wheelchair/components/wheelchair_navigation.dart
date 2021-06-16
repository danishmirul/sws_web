import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/location_controller.dart';
import 'package:sws_web/controllers/message_controller.dart';
import 'package:sws_web/controllers/navigation_controller.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/location.dart';
import 'package:sws_web/models/message.dart';
import 'package:sws_web/models/navigation.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class WheelchairNavigation extends StatefulWidget {
  WheelchairNavigation(
      {@required this.wheelchair, @required this.route, Key key})
      : super(key: key);
  final Wheelchair wheelchair;
  final String route;

  @override
  _ViewMessagesState createState() => _ViewMessagesState();
}

class _ViewMessagesState extends State<WheelchairNavigation> {
  Navigation _navigation;
  bool init = false;
  bool isLoading = false;
  String origin = '', dest = '';

  final List<String> locationsName = [
    'C',
    'P',
    'WR',
    'S',
    'CR1',
    'CR2',
    'X',
    'CR3',
    'RR',
  ];

  @override
  void initState() {
    super.initState();
    init = true;
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    LocationController locationController =
        LocationController(firestoreService: firestoreService);
    NavigationController navigationController =
        NavigationController(firestoreService: firestoreService);

    final Size _size = MediaQuery.of(context).size;
    double _height = _size.height;
    double _width = _size.width * (Responsive.isDesktop(context) ? 0.5 : 0.8);
    double _lengthBtn = (_width / 5) - 10;
    bool enabled = false;

    return FutureBuilder(
        future: navigationController.fetchNavigation(widget.wheelchair.uid),
        builder: (context, snapshot) {
          Widget content = Loading();
          if (snapshot.hasData && snapshot.data['status']) {
            _navigation = snapshot.data['data'];
            if (_navigation.instruction.isEmpty) {
              content = Container(
                height: _height,
                width: _width,
                padding: EdgeInsets.all(kDefaultPadding),
                // width: 222.0,
                child: Column(
                  children: [
                    SizedBox(
                      height: _lengthBtn * 3,
                      width: _lengthBtn * 5,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'P')
                                      origin = '';
                                    else if (dest == 'P')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'P';
                                    else if (origin.isNotEmpty && origin != 'P')
                                      dest = 'P';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'P'
                                        ? Colors.green
                                        : dest == 'P'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'P',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'R')
                                      origin = '';
                                    else if (dest == 'R')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'R';
                                    else if (origin.isNotEmpty && origin != 'R')
                                      dest = 'R';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'R'
                                        ? Colors.green
                                        : dest == 'R'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'R',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'WR')
                                      origin = '';
                                    else if (dest == 'WR')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'WR';
                                    else if (origin.isNotEmpty &&
                                        origin != 'WR') dest = 'WR';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn * 2,
                                  decoration: BoxDecoration(
                                    color: origin == 'WR'
                                        ? Colors.green
                                        : dest == 'WR'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'WR',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'S')
                                      origin = '';
                                    else if (dest == 'S')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'S';
                                    else if (origin.isNotEmpty && origin != 'S')
                                      dest = 'S';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'S'
                                        ? Colors.green
                                        : dest == 'S'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'S',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                if (origin == 'C')
                                  origin = '';
                                else if (dest == 'C')
                                  dest = '';
                                else if (origin.isEmpty)
                                  origin = 'C';
                                else if (origin.isNotEmpty && origin != 'C')
                                  dest = 'C';
                              });
                            },
                            child: Container(
                              height: _lengthBtn,
                              width: _lengthBtn * 5,
                              decoration: BoxDecoration(
                                color: origin == 'C'
                                    ? Colors.green
                                    : dest == 'C'
                                        ? Colors.indigo
                                        : Colors.white,
                                border:
                                    Border.all(color: kPrimaryColor, width: 3),
                              ),
                              child: Center(
                                child: Text(
                                  'C',
                                  style: TextStyle(
                                      color: kSecondaryColor,
                                      fontSize: Responsive.isDesktop(context)
                                          ? 24
                                          : 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'CR1')
                                      origin = '';
                                    else if (dest == 'CR1')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'CR1';
                                    else if (origin.isNotEmpty &&
                                        origin != 'CR1') dest = 'CR1';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'CR1'
                                        ? Colors.green
                                        : dest == 'CR1'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'CR1',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'CR2')
                                      origin = '';
                                    else if (dest == 'CR2')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'CR2';
                                    else if (origin.isNotEmpty &&
                                        origin != 'CR2') dest = 'CR2';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'CR2'
                                        ? Colors.green
                                        : dest == 'CR2'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'CR2',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'X')
                                      origin = '';
                                    else if (dest == 'X')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'X';
                                    else if (origin.isNotEmpty && origin != 'X')
                                      dest = 'X';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'X'
                                        ? Colors.green
                                        : dest == 'X'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'X',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'CR3')
                                      origin = '';
                                    else if (dest == 'CR3')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'CR3';
                                    else if (origin.isNotEmpty &&
                                        origin != 'CR3') dest = 'CR3';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'CR3'
                                        ? Colors.green
                                        : dest == 'CR3'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'CR3',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (origin == 'RR')
                                      origin = '';
                                    else if (dest == 'RR')
                                      dest = '';
                                    else if (origin.isEmpty)
                                      origin = 'RR';
                                    else if (origin.isNotEmpty &&
                                        origin != 'RR') dest = 'RR';
                                  });
                                },
                                child: Container(
                                  height: _lengthBtn,
                                  width: _lengthBtn,
                                  decoration: BoxDecoration(
                                    color: origin == 'RR'
                                        ? Colors.green
                                        : dest == 'RR'
                                            ? Colors.indigo
                                            : Colors.white,
                                    border: Border.all(
                                        color: kPrimaryColor, width: 3),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'RR',
                                      style: TextStyle(
                                          color: kSecondaryColor,
                                          fontSize:
                                              Responsive.isDesktop(context)
                                                  ? 24
                                                  : 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Origin: $origin',
                      style: TextStyle(
                          color: Colors.green,
                          fontSize: Responsive.isDesktop(context) ? 24 : 16,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Destination: $dest',
                      style: TextStyle(
                          color: Colors.indigo,
                          fontSize: Responsive.isDesktop(context) ? 24 : 16,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
              enabled = true;
            } else
              content = Text(
                'There is instruction that still running.',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: Responsive.isDesktop(context) ? 24 : 16,
                    fontWeight: FontWeight.bold),
              );
          } else if (snapshot.hasData && !snapshot.data['status']) {
            content = Text(
              'Please enable Semi-auto navigation in the app.',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: Responsive.isDesktop(context) ? 24 : 16,
                  fontWeight: FontWeight.bold),
            );
          }

          return AlertDialog(
            backgroundColor: kBgColor,
            title: new Text(
              'Wheelchair ${widget.wheelchair.plate}',
              style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: Responsive.isDesktop(context) ? 24 : 16,
                  fontWeight: FontWeight.bold),
            ),
            content: content,
            actions: <Widget>[
              new TextButton(
                child: new CustomText(
                  text: 'Cancel',
                  color: Colors.red,
                  weight: FontWeight.bold,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(width: kDefaultPadding),
              enabled
                  ? new TextButton(
                      child: Row(
                        children: [
                          Icon(
                            Icons.save,
                            color: kSecondaryColor,
                          ),
                          CustomText(
                            text: 'Save',
                            color: kSecondaryColor,
                            weight: FontWeight.bold,
                          ),
                        ],
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = true;
                        });
                        if (origin.isNotEmpty && dest.isNotEmpty) {
                          _save(context);
                        } else {
                          setState(() {
                            isLoading = false;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Complete the form.')));
                        }
                      },
                    )
                  : Container(),
            ],
          );
        });
  }

  Future<void> _save(BuildContext context) async {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    LocationController locationController =
        LocationController(firestoreService: firestoreService);
    NavigationController navigationController =
        NavigationController(firestoreService: firestoreService);

    final result =
        await navigationController.fetchNavigation(widget.wheelchair.uid);
    if (!result['status']) {
      setState(() {
        isLoading = false;
      });
    }
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);
      final NavigationController navigationController =
          NavigationController(firestoreService: database);

      Navigation temp = Navigation.copy(_navigation);
      temp.instruction = '$origin-$dest';
      temp.createdAt = DateTime.now();

      print('NAVIGATION: $temp');

      bool success = await navigationController.updateNavigation(temp);

      setState(() {
        isLoading = false;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, widget.route);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved Successfully')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }
}
