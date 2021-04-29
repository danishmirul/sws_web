import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants/size.dart';
import 'package:sws_web/constants/string.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/pages/staff/staff_detail.dart';
import 'package:sws_web/services/firebase_auth_service.dart';
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

class StaffList extends StatefulWidget {
  StaffList({Key key, this.callback}) : super(key: key);
  final Function callback;

  @override
  _StaffListState createState() => _StaffListState();
}

class _StaffListState extends State<StaffList> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  List<DataColumn> _dataColumns = [];
  List<DataRow> _dataRows = [];
  List<User> _users = [];

  String _mode = 'view';
  bool _showPassword = false;
  bool _showConfirmPassword = false;

  String _password, _confirmPassword;

  User _newUser = new User();
  User _selectedUser = new User();

  Size size;

  bool isLoading = false;
  bool _showError = false;

  void resetForm() {
    setState(() {
      _showError = false;
      _newUser = User();
      _selectedUser = User();
    });
  }

  Future<void> _save() async {
    try {
      // Save to Firestore
      final database = Provider.of<FirestoreService>(context, listen: false);

      final auth = Provider.of<FirebaseAuthService>(context, listen: false);
      if (_mode == 'create') {
        _newUser.accessible = true;
        auth.signUpEmailPassword(email: _newUser.email, password: _password);
        await database.createUserReference(_newUser);
        print('Done Firestore');
      } else if (_mode == 'update') {
        await database.setUserReference(_selectedUser);
        print('Done Firestore');
      } else {
        await database.setUserReference(_selectedUser);
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
      tooltip: 'The unique ID of the staff',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Full Name',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The full name of the staff',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'E-mail',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The email of the staff',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Phone',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'The phone number of the staff',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Hotline',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'Whether the staff included into hotline care number.',
    ));

    _dataColumns.add(DataColumn(
      label: Text(
        'Accessibility',
        style: _headerStyle,
      ),
      numeric: false,
      onSort: (columnIndex, ascending) {},
      tooltip: 'Accessibility of the staff.',
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

    _users.forEach((e) {
      List<DataCell> _cells = [];

      _cells.add(DataCell(Text(
        e.uid.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.fullname.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.email.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(Text(
        e.phone.toString(),
        style: _bodyStyle,
      )));

      _cells.add(DataCell(_buildHotlineStatus(e.hotline)));
      _cells.add(DataCell(_buildStaffStatus(e.accessible)));

      _cells.add(DataCell(Row(
        children: [
          IconButton(
            onPressed: () {
              if (widget.callback != null)
                widget.callback(StaffDetail(uid: e.uid));
            },
            icon: Icon(
              Icons.remove_red_eye,
              color: Colors.blue[900],
            ),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _selectedUser = User.copy(e);
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
              _selectedUser = User.copy(e);
              _selectedUser.accessible = !_selectedUser.accessible;
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

  Widget _buildFullNameField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Full Name'),
      validator: (String value) {
        if (value.isEmpty) {
          return 'Full name is required.';
        } else
          return null;
      },
      initialValue: _mode == 'update' ? _selectedUser.fullname : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedUser.fullname = value
              : _newUser.fullname = value;
        });
      },
    );
  }

  Widget _buildEmailField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Email'),
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_EMAIL;
        }

        if (!RegExp(REG_EXP_EMAIL).hasMatch(value)) {
          return INVALID_EMAIL;
        }

        return null;
      },
      onSaved: (String value) {
        _newUser.email = value;
      },
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      decoration: InputDecoration(labelText: 'Phone No.'),
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_PHONE_NO;
        } else
          return null;
      },
      initialValue: _mode == 'update' ? _selectedUser.phone : '',
      onSaved: (String value) {
        setState(() {
          _mode == 'update'
              ? _selectedUser.phone = value
              : _newUser.phone = value;
        });
      },
    );
  }

  Widget _buildPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Password',
        suffixIcon: InkWell(
          onTap: () {
            setState(() {
              _showPassword = !_showPassword;
            });
          },
          child: Icon(_showPassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !_showPassword,
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        if (value.isEmpty) {
          return REQUIRED_PASSWORD;
        }

        if (!RegExp(REG_EXP_PASSWORD).hasMatch(value)) {
          return INVALID_PASSWORD;
        }

        return null;
      },
      onChanged: (String value) {
        _password = value;
      },
    );
  }

  Widget _buildConfirmPasswordField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'Confirm Password',
        suffixIcon: InkWell(
          onHover: (value) {},
          onTap: () {
            setState(() {
              _showConfirmPassword = !_showConfirmPassword;
            });
          },
          child: Icon(
              _showConfirmPassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
      obscureText: !_showConfirmPassword,
      keyboardType: TextInputType.visiblePassword,
      validator: (String value) {
        print(_confirmPassword);
        if (value.isEmpty) {
          return REQUIRED_CONFIRM_PASSWORD;
        }

        if (value != _password) {
          return INVALID_CONFIRM_PASSWORD;
        }

        return null;
      },
      onChanged: (String value) {
        _confirmPassword = value;
      },
    );
  }

  Widget _buildHotlineField() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: cDefaultPadding),
        CustomText(text: 'Hotline Support'),
        ButtonBar(
          alignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Radio(
                  value: true,
                  groupValue: _mode == 'update'
                      ? _selectedUser.hotline
                      : _newUser.hotline,
                  onChanged: (value) {
                    setState(() {
                      _mode == 'update'
                          ? _selectedUser.hotline = value
                          : _newUser.hotline = value;
                    });
                  },
                ),
                CustomText(text: 'Included')
              ],
            ),
            SizedBox(width: cDefaultPadding),
            Row(
              children: [
                Radio(
                  value: false,
                  groupValue: _mode == 'update'
                      ? _selectedUser.hotline
                      : _newUser.hotline,
                  onChanged: (value) {
                    setState(() {
                      setState(() {
                        _mode == 'update'
                            ? _selectedUser.hotline = value
                            : _newUser.hotline = value;
                      });
                    });
                  },
                ),
                CustomText(text: 'Not Included')
              ],
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStaffStatus(bool param) {
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

  Widget _buildHotlineStatus(bool param) {
    if (param) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Center(
          child: Text(
            'Included',
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
            'Not Included',
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

  Widget _buildStaffsTable(Size _size) => SingleChildScrollView(
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
                  'New Staff Form',
                  style: _headerStyle,
                ),
                _buildFullNameField(),
                _buildEmailField(),
                _buildPhoneField(),
                _buildPasswordField(),
                _buildConfirmPasswordField(),
                _buildHotlineField(),
                SizedBox(height: cDefaultPadding),
                CustomAlert(
                  text: 'Error occured. Please try again',
                  show: _showError,
                  type: 'danger',
                ),
                SizedBox(height: cDefaultPadding),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _save();
                    } else {
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
                  'Update Staff Form UID: ${_selectedUser.uid}',
                  style: _headerStyle,
                ),
                _buildFullNameField(),
                _buildPhoneField(),
                _buildHotlineField(),
                SizedBox(height: cDefaultPadding),
                CustomAlert(
                  text: 'Error occured. Please try again',
                  show: _showError,
                  type: 'danger',
                ),
                SizedBox(height: cDefaultPadding),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey2.currentState.validate()) {
                      _formKey2.currentState.save();
                      _save();
                    } else {
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
    size = MediaQuery.of(context).size;
    return StreamBuilder(
      stream: Firestore.instance.collection(FirestorePath.users()).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _users = [];
          List snapshots = snapshot.data.documents.toList();
          snapshots.forEach((snapshot) {
            User temp = User.fromSnapShot(snapshot);
            _users.add(temp);
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
                          PageHeader(text: 'Staffs Management'),
                          Spacer(),
                          _mode == 'create' || _mode == 'update'
                              ? TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _mode = 'view';
                                      _newUser = new User();
                                      _selectedUser = new User();
                                    });
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
                                  },
                                  child: Container(
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Icon(Icons.create),
                                        Text('New Staff')
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
                              : _buildStaffsTable(size),
                    ],
                  )
                : Loading(),
          ),
        );
      },
    );
  }
}
