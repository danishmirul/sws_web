import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/wheelchair_controller.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';

class CreateWheelchairButton extends StatelessWidget {
  const CreateWheelchairButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding * 1.5,
          vertical: kDefaultPadding / (Responsive.isMobile(context) ? 2 : 1),
        ),
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CreateWheelchairForm(route: HOME_ROUTE);
          },
        );
      },
      icon: Icon(
        Icons.add,
        size: Responsive.isMobile(context) ? 12 : 18,
      ),
      label: Text(
        "Add New",
        style: TextStyle(fontSize: Responsive.isMobile(context) ? 12 : 18),
      ),
    );
  }
}

class CreateWheelchairForm extends StatefulWidget {
  CreateWheelchairForm({@required this.route, Key key}) : super(key: key);
  final String route;

  @override
  _CreateWheelchairFormState createState() => _CreateWheelchairFormState();
}

class _CreateWheelchairFormState extends State<CreateWheelchairForm> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _showError = false;

  Wheelchair _newWheelchair = new Wheelchair(status: 'A', battery: 'HIGH');

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'New Wheelchair Form',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: isLoading
          ? Loading()
          : Container(
              height:
                  _size.height * (Responsive.isDesktop(context) ? 0.4 : 0.5),
              width:
                  (_size.width * (Responsive.isDesktop(context) ? 0.5 : 0.8)),
              padding: EdgeInsets.all(kDefaultPadding),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    _buildPlateField(),
                    SizedBox(height: kDefaultPadding),
                    _buildNameField(),
                    SizedBox(height: kDefaultPadding),
                    _buildAddressField(),
                    SizedBox(height: kDefaultPadding),
                    _buildStatusField(),
                    SizedBox(height: kDefaultPadding),
                    _buildBatteryField(),
                    SizedBox(height: kDefaultPadding),
                    CustomAlert(
                      text: 'Error occured. Please try again',
                      show: _showError,
                      type: 'danger',
                    ),
                    SizedBox(height: kDefaultPadding),
                  ],
                ),
              ),
            ),
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
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();
              _save();
            } else {
              setState(() {
                isLoading = false;
              });
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Complete the form.')));
            }
          },
        ),
      ],
    );
  }

  Future<void> _save() async {
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);
      final WheelchairController wheelchairController =
          WheelchairController(firestoreService: database);

      _newWheelchair.accessible = true;
      bool success =
          await wheelchairController.createNewWheelchair(_newWheelchair);

      setState(() {
        isLoading = false;
        _newWheelchair = new Wheelchair(status: 'A', battery: 'HIGH');

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

  Widget _buildPlateField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          style: TextStyle(
              color: Colors.indigo,
              fontSize: Responsive.isMobile(context) ? 12 : 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Plate',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.wheelchair_pickup_rounded,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else
              return null;
          },
          onSaved: (String value) {
            setState(() {
              _newWheelchair.plate = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          style: TextStyle(
              color: Colors.indigo,
              fontSize: Responsive.isMobile(context) ? 12 : 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Device Name',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.devices,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else
              return null;
          },
          onSaved: (String value) {
            setState(() {
              _newWheelchair.name = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildAddressField() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: TextFormField(
          style: TextStyle(
              color: Colors.indigo,
              fontSize: Responsive.isMobile(context) ? 12 : 18),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Device Address',
            hintStyle: TextStyle(color: Colors.grey),
            icon: Icon(
              Icons.tag,
              color: Colors.indigo,
            ),
          ),
          validator: (String value) {
            if (value.isEmpty) {
              return REQUIRED_FIELD;
            } else
              return null;
          },
          onSaved: (String value) {
            setState(() {
              _newWheelchair.address = value;
            });
          },
        ),
      ),
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
                value: _newWheelchair.status,
                onChanged: (value) {
                  setState(() {
                    _newWheelchair.status = value;
                  });
                },
              )
            ],
          )),
    );
  }

  Widget _buildBatteryField() {
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
                'Battery',
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
                  DropdownMenuItem(value: 'HIGH', child: Text('High')),
                  DropdownMenuItem(value: 'LOW', child: Text('Low')),
                ],
                value: _newWheelchair.battery,
                onChanged: (value) {
                  setState(() {
                    _newWheelchair.battery = value;
                  });
                },
              )
            ],
          )),
    );
  }
}
