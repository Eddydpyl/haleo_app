import 'package:flutter/material.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/state_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../blocs/state_bloc.dart';
import '../../../blocs/event_bloc.dart';
import '../../../blocs/message_admin_bloc.dart';
import '../../../models/message.dart';
import '../../../models/user.dart';
import '../../../utility.dart';

class ChatBody extends StatefulWidget {
  final String eventKey;

  ChatBody(this.eventKey);

  @override
  _ChatBodyState createState() => _ChatBodyState();
}

class _ChatBodyState extends State<ChatBody> {
  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final StateBloc stateBloc = StateProvider.stateBloc(context);
    final EventBloc eventBloc = ChatProvider.eventBloc(context);
    final MessageAdminBloc messageAdminBloc = ChatProvider.messageAdminBloc(context);
    return StreamBuilder(
      stream: stateBloc.userKeyStream,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data;
          return StreamBuilder(
            stream: eventBloc.messagesStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, Message>> snapshot) {
              if (snapshot.data != null) {
                // Every time we receive messages, we update
                // the date at which we last read the event's messages.
                ApplicationProvider.preferences(context).read(widget.eventKey);
                Map<String, Message> messages = snapshot.data;
                List<String> sorted = messages.keys.toList()
                  ..sort((String a, String b) => messages[b].date
                      .compareTo(messages[a].date));
                return StreamBuilder(
                  stream: eventBloc.usersStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, User>> snapshot) {
                    if (snapshot.data != null) {
                      Map<String, User> users = snapshot.data;
                      return GestureDetector(
                        onTap: () => FocusScope.of(context).unfocus(),
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: ListView.builder(
                                reverse: true,
                                padding: EdgeInsets.all(16.0),
                                itemCount: messages.length,
                                itemBuilder: (BuildContext context, int index) {
                                  Message message = messages[sorted[index]];
                                  return MessageBubble(
                                    message: message,
                                    user: users[message.user],
                                    direction: message.user == userKey,
                                    spacing: width / 4,
                                  );
                                },
                              ),
                            ),
                            MessageComposer(
                              messageAdminBloc: messageAdminBloc,
                              eventKey: widget.eventKey,
                              userKey: userKey,
                            ),
                          ],
                        ),
                      );
                    } else
                      return Center(
                        child: const CircularProgressIndicator(),
                      );
                  },
                );
              } else
                return Center(
                  child: const CircularProgressIndicator(),
                );
            },
          );
        } else
          return Center(
            child: const CircularProgressIndicator(),
          );
      },
    );
  }
}

class MessageComposer extends StatefulWidget {
  final MessageAdminBloc messageAdminBloc;
  final String eventKey;
  final String userKey;

  MessageComposer({
    @required this.messageAdminBloc,
    @required this.eventKey,
    @required this.userKey,
  });

  @override
  _MessageComposerState createState() => _MessageComposerState();
}

class _MessageComposerState extends State<MessageComposer> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      color: Colors.white,
      height: 64,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              controller: controller,
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration.collapsed(hintText: ApplicationProvider
                  .localization(context).messageHintText()),
            ),
          ),
          IconButton(
            iconSize: 25.0,
            color: Colors.grey,
            icon: Icon(Icons.send),
            onPressed: () {
              if (controller.text?.isNotEmpty ?? false) {
                widget.messageAdminBloc.createSink.add(Message(
                  event: widget.eventKey,
                  user: widget.userKey,
                  date: DateUtility.currentDate(),
                  data: controller.text,
                  type: MessageType.text,
                ));
                FocusScope.of(context).unfocus();
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}

class MessageBubble extends StatelessWidget {
  final Message message;
  final User user;
  final bool direction;
  final double spacing;
  final Color userColor;

  MessageBubble({
    @required this.message,
    @required this.user,
    @required this.direction,
    @required this.spacing,
  }) : userColor = assignColor(user, direction);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: direction
          ? EdgeInsets.only(top: 8.0, bottom: 8.0, left: spacing)
          : EdgeInsets.only(top: 8.0, bottom: 8.0, right: spacing),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: userColor,
          width: 2.0,
        ),
        borderRadius: direction
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
            user?.name ?? "",
            style: TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
              color: userColor,
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            DateUtility.formatFullDate(message.date),
            style: TextStyle(
              fontSize: 12.0,
              color: Color(0xFF424242),
            ),
          ),
          SizedBox(height: 2.0),
          Text(
            message.data,
            style: TextStyle(
              fontSize: 16.0,
              color: Color(0xFF424242),
            ),
          ),
        ],
      ),
    );
  }

  // Assigns "unique" color to a given user
  static Color assignColor(User user, bool direction) {
    List<Color> colors = [
      Colors.blue,
      Colors.pink,
      Colors.purple,
      Colors.green,
      Colors.orange,
      Colors.teal,
    ];

    if (direction) return Colors.red;
    return colors[(user?.email?.length ?? 0) % colors.length];
  }
}
