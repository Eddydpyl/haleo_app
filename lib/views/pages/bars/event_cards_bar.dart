import 'package:flutter/material.dart';

import '../../../providers/perimeter_events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';
import '../event_listing_page.dart';
import 'default_bar.dart';

class EventCardsBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: PerimeterEventsProvider.userBloc(context).userStream,
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
        text: "¡hal",
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
        icon: Icon(CustomIcons.chat),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => EventListingPage(),
          ));
        },
      ),
      colorA: Color(0xfffa6b40),
      colorB: Color(0xfffd1d1d),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
