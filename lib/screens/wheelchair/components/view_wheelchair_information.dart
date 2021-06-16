import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/screens/wheelchair/components/live_camera.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/progress_line.dart';
import 'package:web_socket_channel/html.dart';
import 'package:web_socket_channel/io.dart';

class ViewWheelchairInformation extends StatelessWidget {
  const ViewWheelchairInformation({@required this.data, Key key})
      : super(key: key);
  final Wheelchair data;

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    WheelchairController wheelchairController =
        WheelchairController(firestoreService: firestoreService);

    final Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'Wheelchair ${data.plate}',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: Container(
        // height: _size.height * (Responsive.isDesktop(context) ? 0.3 : 0.3),
        width: _size.width * (Responsive.isDesktop(context) ? 0.3 : 0.5),
        padding: EdgeInsets.all(kDefaultPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(kDefaultPadding * 0.75),
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: kSecondaryColor.withOpacity(0.1),
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Image.asset(
                      'icons/wheelchair_96px.png',
                      color: kSecondaryColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(kDefaultPadding * 0.75),
                height: _size.height * 0.5,
                width: double.infinity,
                child: LiveCamera(
                  channel: HtmlWebSocketChannel.connect(
                      Uri.parse('ws://192.168.8.102:8888')),
                ),
              ),
              Text(
                data.plate,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: Responsive.isDesktop(context) ? 22 : 14),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Device ${data.name.toUpperCase()}",
                    style: TextStyle(
                        color: kSecondaryColor.withOpacity(.7),
                        fontSize: Responsive.isDesktop(context) ? 20 : 12),
                  ),
                  Text(
                    "Battery ${data.battery.toUpperCase()}",
                    style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: Responsive.isDesktop(context) ? 20 : 12),
                  ),
                ],
              ),
              ProgressLine(
                color: data.battery == 'HIGH' ? Colors.green : Colors.red,
                percentage: data.battery == 'HIGH' ? 100 : 30,
              ),
              Text(
                "Status ${wheelchairController.getStatusString(data.status).toUpperCase()}",
                style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: Responsive.isDesktop(context) ? 20 : 12),
              ),
              Text(
                "Accessibility ${wheelchairController.getAccessibilityString(data.accessible).toUpperCase()}",
                style: TextStyle(
                    color: kSecondaryColor,
                    fontSize: Responsive.isDesktop(context) ? 20 : 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
