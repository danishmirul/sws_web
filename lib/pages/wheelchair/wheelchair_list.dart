import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/constants/string.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/pages/wheelchair/wheelchair_detail.dart';
import 'package:sws_web/services/firestore_path.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/custom_alert.dart';
import 'package:sws_web/widgets/custom_text.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:sws_web/widgets/page_header.dart';
import 'package:sws_web/widgets/paginated_table.dart';

TextStyle _headerStyle = TextStyle(
    color: Colors.blue.shade900, fontSize: 24.0, fontWeight: FontWeight.bold);
const TextStyle _bodyStyle =
    TextStyle(color: Colors.blue, fontSize: 16.0, fontWeight: FontWeight.bold);

class WheelchairList extends StatefulWidget {
  WheelchairList({Key key, this.callback}) : super(key: key);
  final Function callback;

  @override
  _WheelchairListState createState() => _WheelchairListState();
}

class _WheelchairListState extends State<WheelchairList> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<DataColumn> _dataColumns = [];
  List<DataRow> _dataRows = [];
  List<Wheelchair> _wheelchairs = [];
  bool isLoading = false;
  bool _showError = false;

  String _mode = 'view';

  Wheelchair _newWheelchair = new Wheelchair();
  Wheelchair _selectedWheelchair = new Wheelchair();

  void resetForm() {
    setState(() {
      _showError = false;
      _newWheelchair = Wheelchair();
      _selectedWheelchair = Wheelchair();
    });
  }

  Future<void> _save() async {
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);
      if (_mode == 'create') {
        _newWheelchair.battery = 'HIGH';
        _newWheelchair.accessible = true;
        _newWheelchair.status = 'A';
        await database.createWheelchairReference(_newWheelchair);
        print('Done Firestore');
      } else if (_mode == 'update') {
        await database.setWheelchairReference(_selectedWheelchair);
        print('Done Firestore');
      } else {
        print('Save: ${_selectedWheelchair.toString()}');
        await database.setWheelchairReference(_selectedWheelchair);
        print('Done Firestore');
      }

      setState(() {
        isLoading = false;
        _mode = 'view';
      });
      resetForm();

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Saved Successfully')));
    } catch (e) {
      setState(() {
        isLoading = false;
        _showError = true;
      });
    }
  }

  void _buildDataColumn() {
    List<DataColumn> _dataColumns = [];

    _dataColumns.add(DataColumn(
      label: Text(
        'UID',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The unique ID of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Name',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The name of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Address',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The address of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Plate',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The plate number of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Status',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The status of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Battery Reading',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The battery reading of the wheelchair',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Accessibility',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'Accessibility of the wheelchair.',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Actions',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: '',
    ));

    this._dataColumns = _dataColumns;
  }

  void _buildDataRow() {
    List<DataRow> _dataRows = [];

    _wheelchairs.forEach((e) {
      List<DataCell> _cells = [];

      _cells.add(DataCell(Text(
        e.uid.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.name.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.address.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.plate.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(_buildStatusText(e.status.toString())));

      _cells.add(DataCell(_buildBatteryText(e.battery)));

      _cells.add(DataCell(_buildAccessibilityText(e.accessible)));

      _cells.add(DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.callback != null)
                widget.callback(WheelchairDetail(uid: e.uid));
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.blue[900],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedWheelchair = Wheelchair.copy(e);
                _mode = 'update';
              });
            },
            icon: Icon(
              Icons.edit,
              color: Colors.blue[900],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                isLoading = true;
              });
              _selectedWheelchair = Wheelchair.copy(e);
              _selectedWheelchair.accessible = !_selectedWheelchair.accessible;
              _save();
            },
            icon: Icon(
              e.accessible ? Icons.delete : Icons.accessibility,
              color: e.accessible ? Colors.red[900] : Colors.green[900],
            ),
          )
        ],
      )));
      _dataRows.add(DataRow(cells: _cells));
    });

    this._dataRows = _dataRows;
  }

  Widget _buildNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_PLATE_NO;
        } else
          return null;
      },
      initialValue: _mode == 'update' ? _selectedWheelchair.name : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedWheelchair.name = value
              : _newWheelchair.name = value;
        });
      },
    );
  }

  Widget _buildAddressField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Address'),
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_PLATE_NO;
        } else
          return null;
      },
      initialValue: _mode == 'update' ? _selectedWheelchair.address : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedWheelchair.address = value
              : _newWheelchair.address = value;
        });
      },
    );
  }

  Widget _buildPlateField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Plate No.'),
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_PLATE_NO;
        } else
          return null;
      },
      initialValue: _mode == 'update' ? _selectedWheelchair.plate : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedWheelchair.plate = value
              : _newWheelchair.plate = value;
        });
      },
    );
  }

  Widget _buildStatusField() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: cDefaultPadding * 2),
        CustomText(text: 'Status'),
        SizedBox(width: cDefaultPadding * 2),
        DropdownButton(
          items: [
            DropdownMenuItem(value: 'A', child: Text('Available')),
            DropdownMenuItem(value: 'C', child: Text('Charging')),
            DropdownMenuItem(value: 'U', child: Text('Unavailable')),
          ],
          value: _mode == 'update' ? _selectedWheelchair.status : '',
          onChanged: (value) {
            setState(() {
              _mode == 'update'
                  ? _selectedWheelchair.status = value
                  : _newWheelchair.status = value;
            });
          },
        )
      ],
    );
  }

  Widget _buildBatteryField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Battery.'),
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (String value) {
        if (value.isEmpty) {
          setState(() {
            _mode == 'update'
                ? _selectedWheelchair.battery = 'LOW'
                : _newWheelchair.battery = 'LOW';
          });
          return REQUIRED_BATTERY;
        } else
          return null;
      },
      initialValue:
          _mode == 'update' ? _selectedWheelchair.battery.toString() : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedWheelchair.battery = value
              : _newWheelchair.battery = value;
        });
      },
    );
  }

  Widget _buildStatusText(param) {
    switch (param) {
      case 'A':
        return Container(
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              'Available',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        break;
      case 'C':
        return Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              'Charging',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        break;
      case 'U':
      default:
        return Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              'Unavailable',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildBatteryText(param) {
    if (param == 'HIGH') {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            '$param',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.only(right: cDefaultPadding * 2),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          child: Center(
            child: Text(
              '$param',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildAccessibilityText(bool param) {
    if (param) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            'Active',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            'Inactive',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }
  }

  Widget _buildWheelchairsTable(Size _size) => SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: cDefaultPadding),
          child: Container(
            height: _size.height * 0.70,
            width: _size.width - cNavbarWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey[300],
                    offset: Offset(0, 3),
                    blurRadius: 16)
              ],
            ),
            child: PaginatedTable(
              columns: _dataColumns,
              rows: _dataRows,
            ),
          ),
        ),
      );

  Widget _buildForm(Size _size) => Center(
        child: Container(
          height: _size.height * 0.7,
          width: (_size.width * 0.5) - (cNavbarWidth * 2),
          padding: EdgeInsets.all(cDefaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
            ],
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'New Wheelchair Form',
                  style: _headerStyle,
                ),
                _buildNameField(),
                _buildAddressField(),
                _buildPlateField(),
                SizedBox(height: cDefaultPadding),
                CustomAlert(
                  text: 'Error occured. Please try again',
                  show: _showError,
                  type: 'danger',
                ),
                SizedBox(height: cDefaultPadding),
                ElevatedButton(
                  onPressed: () {
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
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Complete the form.')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildUpdateForm(Size _size) => Center(
        child: Container(
          height: _size.height * 0.7,
          width: (_size.width * 0.5) - (cNavbarWidth * 2),
          padding: EdgeInsets.all(cDefaultPadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey[300], offset: Offset(0, 3), blurRadius: 16)
            ],
          ),
          child: Form(
            key: _formKey2,
            child: Column(
              children: <Widget>[
                Text(
                  'Update Wheelchair Form UID: ${_selectedWheelchair.uid}',
                  style: _headerStyle,
                ),
                _buildNameField(),
                _buildAddressField(),
                _buildPlateField(),
                _buildStatusField(),
                // _buildBatteryField(),
                SizedBox(height: cDefaultPadding),
                CustomAlert(
                  text: 'Error occured. Please try again',
                  show: _showError,
                  type: 'danger',
                ),
                SizedBox(height: cDefaultPadding),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    if (_formKey2.currentState.validate()) {
                      _formKey2.currentState.save();
                      _save();
                    } else {
                      setState(() {
                        isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Complete the form.')));
                    }
                  },
                  child: Text('Submit'),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance
          .collection(FirestorePath.wheelchairs())
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _wheelchairs = [];
          List snapshots = snapshot.data.documents.toList();
          snapshots.forEach((snapshot) {
            Wheelchair temp = Wheelchair.fromSnapShot(snapshot);
            _wheelchairs.add(temp);
          });
          _buildDataColumn();
          _buildDataRow();
        }

        return SafeArea(
          child: Container(
            height: size.height,
            width: size.width - cNavbarWidth,
            child: snapshot.hasData
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          PageHeader(text: 'Wheelchairs Management'),
                          Spacer(),
                          _mode == 'create' || _mode == 'update'
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _mode = 'view';
                                    });

                                    resetForm();
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.arrow_back),
                                        Text('Return')
                                      ],
                                    ),
                                  ),
                                )
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _mode = 'create';
                                    });

                                    resetForm();
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.create),
                                        Text('New Wheelchair')
                                      ],
                                    ),
                                  ),
                                ),
                          SizedBox(width: cDefaultPadding),
                        ],
                      ),
                      _mode == 'create'
                          ? _buildForm(size)
                          : _mode == 'update'
                              ? _buildUpdateForm(size)
                              : _buildWheelchairsTable(size),
                    ],
                  )
                : Loading(),
          ),
        );
      },
    );
  }
}
