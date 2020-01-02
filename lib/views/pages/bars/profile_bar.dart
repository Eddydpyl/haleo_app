import 'package:flutter/material.dart';
import 'package:haleo_app/views/pages/bars/default_bar.dart';

import '../../../providers/user_events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: UserEventsProvider.userBloc(context).userStream,
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
        } else
          return Container();
      },
    );
  }

  Widget titleWidget() {
    return RichText(
        text: TextSpan(
      text: "¡Tu Cara!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF424242),
        fontSize: 24.0,
      ),
    ));
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
