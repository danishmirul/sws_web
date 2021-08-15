import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/progress_line.dart';

import '../../../constants.dart';

class WheelchairInfoCard extends StatelessWidget {
  const WheelchairInfoCard({@required this.data, @required this.route, Key key})
      : super(key: key);
  final Wheelchair data;
  final String route;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: Colors.lightBlueAccent.shade700,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
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
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Image.asset(
                  'icons/wheelchair_96px.png',
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white54),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return UpdateForm(route: route, data: data, size: _size);
                    },
                  );
                },
              )
            ],
          ),
          Text(
            data.plate,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Device ${data.name.toUpperCase()}",
                style: TextStyle(
                    color: Colors.white70,
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
              ),
              Text(
                "Battery ${data.battery.toUpperCase()}",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: Responsive.isDesktop(context) ? 12 : 10),
              ),
            ],
          ),
          ProgressLine(
            color: data.battery == 'HIGH' ? Colors.green : Colors.red,
            percentage: data.battery == 'HIGH' ? 100 : 30,
          ),
          Text(
            "Status AVAILABLE",
            style: Theme.of(context)
                .textTheme
                .caption
                .copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class UpdateForm extends StatefulWidget {
  UpdateForm(
      {@required this.data, @required this.size, @required this.route, Key key})
      : super(key: key);
  final Size size;
  final Wheelchair data;
  final String route;

  @override
  _UpdateFormState createState() => _UpdateFormState();
}

class _UpdateFormState extends State<UpdateForm> {
  Wheelchair data;
  bool isLoading = false;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    data = Wheelchair.copy(widget.data);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'Update Wheelchair Status',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: isLoading
          ? Loading()
          : Container(
              height: widget.size.height *
                  (Responsive.isDesktop(context) ? 0.1 : 0.5),
              width: (widget.size.width *
                  (Responsive.isDesktop(context) ? 0.2 : 0.8)),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                children: [
                  _buildStatusField(),
                  CustomAlert(
                    text: 'Error occured. Please try again',
                    show: _showError,
                    type: 'danger',
                  ),
                ],
              ),
            ),
      actions: isLoading
          ? []
          : <Widget>[
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
              new TextButton(
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
                  _save();
                },
              ),
            ],
    );
  }

  Widget _buildStatusField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: kDefaultPadding * 2),
              Text(
                'Status',
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
              ),
              SizedBox(width: kDefaultPadding * 2),
              DropdownButton(
                style: TextStyle(
                    color: Colors.indigo,
                    fontSize: Responsive.isMobile(context) ? 12 : 18),
                dropdownColor: Colors.white,
                items: [
                  DropdownMenuItem(value: 'A', child: Text('Available')),
                  DropdownMenuItem(value: 'M', child: Text('Mainenance')),
                  DropdownMenuItem(value: 'U', child: Text('In Use')),
                ],
                value: data.status,
                onChanged: (value) {
                  setState(() => data.status = value);
                },
              )
            ],
          )),
    );
  }

  Future<void> _save() async {
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);
      final WheelchairController wheelchairController =
          WheelchairController(firestoreService: database);

      bool success = await wheelchairController.updateWheelchair(data);

      setState(() {
        isLoading = false;

        if (!success) _showError = true;
      });

      if (success) {
        Navigator.pushReplacementNamed(context, widget.route);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Saved Successfully')));
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        _showError = true;
      });
    }
  }
}
