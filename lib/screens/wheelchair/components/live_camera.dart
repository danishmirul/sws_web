import 'package:flutter/material.dart';
import 'package:sws_web/widgets/loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class LiveCamera extends StatefulWidget {
  final WebSocketChannel channel;
  LiveCamera({Key key, @required this.channel}) : super(key: key);

  @override
  _LiveCameraState createState() => _LiveCameraState();
}

class _LiveCameraState extends State<LiveCamera> {
  @override
  void initState() {
    super.initState();
    // IOWebSocketChannel.connect('');
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.channel.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Loading();
        return Image.memory(
          snapshot.data,
          fit: BoxFit.cover,
          gaplessPlayback: true,
        );
      },
    );
  }
}
