import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sws_web/constants.dart';
import 'package:sws_web/controllers/message_controller.dart';
import 'package:sws_web/models/message.dart';
import 'package:sws_web/models/wheelchair.dart';
import 'package:sws_web/responsive.dart';
import 'package:sws_web/services/firestore_service.dart';
import 'package:sws_web/widgets/loading.dart';

class ViewMessages extends StatefulWidget {
  ViewMessages({@required this.wheelchair, Key key}) : super(key: key);
  final Wheelchair wheelchair;

  @override
  _ViewMessagesState createState() => _ViewMessagesState();
}

class _ViewMessagesState extends State<ViewMessages> {
  int length = 10;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
  }

  @override
  Widget build(BuildContext context) {
    FirestoreService firestoreService =
        Provider.of<FirestoreService>(context, listen: false);
    MessageController messageController =
        MessageController(firestoreService: firestoreService);

    final Size _size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: kBgColor,
      title: new Text(
        'Message Log Wheelchair ${widget.wheelchair.plate}',
        style: TextStyle(
            color: kSecondaryColor,
            fontSize: Responsive.isDesktop(context) ? 24 : 16,
            fontWeight: FontWeight.bold),
      ),
      content: Container(
        height: _size.height * .9,
        width: _size.width * (Responsive.isDesktop(context) ? 0.3 : 0.5),
        // width: 222.0,
        child: StreamBuilder(
          stream: messageController
              .wheelchairMessagesStream(widget.wheelchair.uid, length: length),
          builder: (context, snapshot) {
            print('STREAM: $snapshot');
            if (snapshot.hasData) {
              List<Message> messages = [];
              List snapshots = snapshot.data.documents.toList();
              snapshots.forEach((snapshot) {
                Message temp = Message.fromSnapShot(snapshot);
                if (temp.wheelchairId == widget.wheelchair.uid)
                  messages.add(temp);
              });

              final List<Row> chats = messages.map((_message) {
                return Row(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.all(12.0),
                      margin:
                          EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
                      decoration: BoxDecoration(
                          color: _message.whom == 0
                              ? Colors.amber.shade200
                              : kPrimaryColor.shade200,
                          borderRadius: BorderRadius.circular(7.0)),
                      child: Column(
                        children: [
                          Text(
                            '${messageController.getStringSource(_message.whom)}',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize:
                                    Responsive.isDesktop(context) ? 20 : 12),
                          ),
                          Text(
                            'Time Stamp: ${_message.createdAt}',
                            style: TextStyle(
                                color: kSecondaryColor.withOpacity(.7),
                                fontSize:
                                    Responsive.isDesktop(context) ? 20 : 12),
                          ),
                          Text(
                            'Type: ${_message.label}',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize:
                                    Responsive.isDesktop(context) ? 20 : 12),
                          ),
                          Text(
                            'Text: ${_message.text}',
                            style: TextStyle(
                                color: kSecondaryColor,
                                fontSize:
                                    Responsive.isDesktop(context) ? 20 : 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                  mainAxisAlignment: _message.whom == 0
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.start,
                );
              }).toList();
              return ListView.builder(
                controller: scrollController,
                itemCount: chats.length,
                itemBuilder: (context, index) {
                  return chats[index];
                },
              );
            }
            return Loading();
          },
        ),
      ),
    );
  }

  void _scrollListener() {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      print("at the end of list");
      setState(() {
        length += length;
      });
    }
  }
}
