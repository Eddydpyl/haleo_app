import 'package:flutter/material.dart';
import 'package:haleo_app/views/pages/bars/default_bar.dart';

import '../../../providers/user_events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class EventListingBar extends StatelessWidget implements PreferredSizeWidget {
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
        } else return Container();
      },
    );
  }

  Widget titleWidget() {
    return RichText(
      text: TextSpan(
        text: "¡Tus Hal",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
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
            text: "s!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
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