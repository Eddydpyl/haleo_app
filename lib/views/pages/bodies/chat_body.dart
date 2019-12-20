import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:haleo_app/models/message.dart';
import 'package:haleo_app/models/user.dart';
import 'package:haleo_app/views/custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class ChatBody extends StatefulWidget {
  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  User currentUser = User(
      name: 'Miguel',
      description: 'Hello I\'m Miguel!',
      image:
          'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&w=1000&q=80',
      email: 'miestgo@gmail.com');

  Message message = Message(
    user: 'Miguel',
    date: '20/12/2019',
    data: 'Hello world! This is a simple message to test this UI out.',
  );
  List<Message> messages = [];

  _buildMessage(Message message, bool isMe, double spacing) {
    return Container(
      margin: isMe
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: spacing)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: spacing),
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      decoration: BoxDecoration(
        gradient: isMe
            ? LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xfffa6b40), Color(0xfffd1d1d)])
            : LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [Color(0xff348ac7), Color(0xff7474bf)]),
        borderRadius: isMe
            ? BorderRadius.only(
                topLeft: Radius.circular(15.0),
                bottomLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0),
              )
            : BorderRadius.only(
                topRight: Radius.circular(15.0),
                bottomRight: Radius.circular(15.0),
                topLeft: Radius.circular(15.0),
              ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            message.user,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            message.date,
            style: TextStyle(
              fontSize: 12.0,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            message.data,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      height: 64,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
                textCapitalization: TextCapitalization.sentences,
                decoration:
                    InputDecoration.collapsed(hintText: 'Escribir mensaje'),
                onChanged: (value) {} //TODO,
                ),
          ),
          PaintGradient(
            child: IconButton(
              iconSize: 25.0,
              icon: Icon(Icons.send),
              onPressed: () {},
            ),
            colorA: Color(0xfffa6b40),
            colorB: Color(0xfffd1d1d),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: ListView.builder(
                reverse: true,
                padding: EdgeInsets.all(16.0),
                itemCount: 5, // TODO total # of messages
                itemBuilder: (BuildContext context, int index) {
                  // TODO: implement with the list of upcoming messages, second arg should be boolen for "isCurrentUserMessage"
                  return _buildMessage(message, index % 2 == 0, width / 4);
                },
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
  }
}
