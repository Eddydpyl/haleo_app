import 'package:flutter/material.dart';
import 'package:haleo_app/views/pages/bars/default_bar.dart';

import '../../../providers/event_admin_provider.dart';
import '../../../models/user.dart';

class EventAdminBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: EventAdminProvider.userBloc(context).userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final String userKey = snapshot.data.key;
          final User user = snapshot.data.value;
          return DefaultBar(titleWidget(), userKey, user);
        } else return Container();
      },
    );
  }

  Widget titleWidget() {
    return Text(
      "¡Crear haleo!",
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black87,
        fontSize: 24.0,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}