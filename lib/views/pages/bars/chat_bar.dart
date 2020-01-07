import 'package:flutter/material.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/chat_provider.dart';
import '../../../models/user.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../bars/default_bar.dart';
import '../../../localization.dart';

class ChatBar extends StatelessWidget implements PreferredSizeWidget {
  final Event event;

  ChatBar(this.event);

  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    return StreamBuilder(
      stream: ChatProvider.eventBloc(context).eventStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final String eventKey = snapshot.data.key;
          final Event event = snapshot.data.value;
          return StreamBuilder(
            stream: ChatProvider.eventBloc(context).usersStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, User>> snapshot) {
              if (snapshot.data != null) {
                final Map<String, User> users = snapshot.data;
                return StreamBuilder(
                  stream: ChatProvider.userBloc(context).userStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<MapEntry<String, User>> snapshot) {
                    if (snapshot.data != null) {
                      final String userKey = snapshot.data.key;
                      final User user = snapshot.data.value;
                      return DefaultBar(
                        title: titleWidget(context, localization,
                            eventKey, event, users),
                        leading: leadingWidget(context),
                        userKey: userKey,
                        user: user,
                      );
                    } else return Container();
                  },
                );
              } else return Container();
            },
          );
        } else return Container();
      },
    );
  }

  Widget titleWidget(BuildContext context, Localization localization,
      String key, Event event, Map<String, User> users) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Flexible(
          child: Text(
            event.name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
              fontSize: 24.0,
            ),
          ),
        ),
        FlatButton(
          shape: CircleBorder(),
          child: Icon(Icons.info),
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  contentPadding: const EdgeInsets.only(),
                  content: EventCard(
                    localization: localization,
                    eventKey: key,
                    event: event,
                    users: users,
                    showCount: false,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Widget leadingWidget(BuildContext context) {
    return PaintGradient(
      child: IconButton(
        icon: Icon(CustomIcons.left_big),
        onPressed: () => Navigator.of(context).pop(),
      ),
      colorA: Color(0xfffa6b40),
      colorB: Color(0xfffd1d1d),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}