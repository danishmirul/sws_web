import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/controllers/user_controller.dart';
import 'package:sws_web/models/user.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/routing/routes.dart';
import 'package:sws_web/screens/user/components/update_user_form.dart';
import 'package:sws_web/screens/user/components/view_user_information.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';

import '../../../constants.dart';

class UserList extends StatefulWidget {
  UserList({Key key}) : super(key: key);

  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  FirestoreService firestoreService;
  UserController userController;

  List<User> users = [];
  bool next = true;

  @override
  void initState() {
    super.initState();

    firestoreService = Provider.of<FirestoreService>(context, listen: false);
    userController = UserController(firestoreService: firestoreService);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(kDefaultPadding),
      decoration: BoxDecoration(
        color: kSecondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "All Users",
            style: Theme.of(context).textTheme.subtitle1,
          ),
          FutureBuilder<List<User>>(
            future: userController.getPaginatedUser(next: next),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.length > 0) {
                  users = snapshot.data;
                }
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: DataTable(
                        horizontalMargin: 0,
                        columnSpacing: kDefaultPadding,
                        columns: [
                          DataColumn(
                            label: Text(
                              "Full Name",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Phone",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Hotline",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              "Accessibility",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize:
                                      Responsive.isDesktop(context) ? 16 : 8),
                            ),
                          ),
                          DataColumn(
                            label: Text(""),
                          ),
                        ],
                        rows: List.generate(
                          users.length,
                          (index) => wheelchairRow(context, users[index]),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () async {
                              setState(() => next = false);
                            }),
                        IconButton(
                            icon: Icon(Icons.arrow_forward_ios),
                            onPressed: () async {
                              setState(() => next = true);
                            })
                      ],
                    ),
                  ],
                );
              }
              return Loading();
            },
          ),
        ],
      ),
    );
  }
}

DataRow wheelchairRow(BuildContext context, User data) {
  final database = Provider.of<FirestoreService>(context, listen: false);
  final UserController userController =
      UserController(firestoreService: database);

  return DataRow(
    cells: [
      DataCell(
        Row(
          children: [
            Image.asset(
              'images/profile_pic.png',
              height: Responsive.isDesktop(context) ? 30 : 15,
              width: Responsive.isDesktop(context) ? 30 : 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
              child: Text(
                data.fullname,
                style:
                    TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
              ),
            ),
          ],
        ),
      ),
      DataCell(Text(
        data.email,
        style: TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
      )),
      DataCell(Text(
        data.phone,
        style: TextStyle(fontSize: Responsive.isDesktop(context) ? 16 : 8),
      )),
      DataCell(
        Text(
          userController.getHotlineString(data.hotline),
          style: TextStyle(
            color: userController.getHotlineColor(data.hotline),
            fontSize: Responsive.isDesktop(context) ? 16 : 8,
          ),
        ),
      ),
      DataCell(
        Text(
          userController.getAccessibilityString(data.accessible),
          style: TextStyle(
            color: data.accessible ? Colors.green : Colors.red,
            fontSize: Responsive.isDesktop(context) ? 16 : 8,
          ),
        ),
      ),
      DataCell(
        Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return ViewUserInformation(data: data);
                  },
                );
              },
            ),
            SizedBox(width: Responsive.isDesktop(context) ? 16 : 8),
            IconButton(
              icon: Icon(
                Icons.edit,
                size: Responsive.isDesktop(context) ? 16 : 8,
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return UpdateUserForm(
                      data: data,
                      route: HOME_ROUTE,
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    ],
  );
}
