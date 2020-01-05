import 'package:flutter/material.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/event_admin_provider.dart';
import '../../../models/user.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../bars/default_bar.dart';
import '../../../localization.dart';

class EventAdminBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    return StreamBuilder(
      stream: EventAdminProvider.userBloc(context).userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data.key;
          final User user = snapshot.data.value;
          return DefaultBar(
            title: titleWidget(localization),
            leading: leadingWidget(context),
            userKey: userKey,
            user: user,
          );
        } else
          return Container();
      },
    );
  }

  Widget titleWidget(Localization localization) {
    return RichText(
      text: TextSpan(
        text: "${localization.createText()} Hal",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF424242),
          fontSize: 24.0,
        ),
        children: <TextSpan>[
          TextSpan(
            text: "e",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          TextSpan(
            text: "o",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          TextSpan(
            text: "!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF424242),
            ),
          )
        ],
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
