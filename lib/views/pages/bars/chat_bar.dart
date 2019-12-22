import 'package:flutter/material.dart';

import '../../../providers/chat_provider.dart';
import '../../../models/user.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../bars/default_bar.dart';

class ChatBar extends StatelessWidget implements PreferredSizeWidget {
  final Event event;

  ChatBar(this.event);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatProvider.userBloc(context).userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data.key;
          final User user = snapshot.data.value;
          return DefaultBar(
            title: titleWidget(),
            leading: leadingWidget(context),
            userKey: userKey,
            user: user,
          );
        } else return Container();
      },
    );
  }

  Widget titleWidget() {
    return Text(
      event.name,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
        fontSize: 24.0,
      ),
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