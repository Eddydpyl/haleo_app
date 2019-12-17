import 'package:flutter/material.dart';
import 'package:haleo_app/views/pages/bars/default_bar.dart';

import '../../../providers/events_provider.dart';
import '../../../models/user.dart';

class EventsBar extends StatelessWidget implements PreferredSizeWidget {
 @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: EventsProvider.userBloc(context).userStream,
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
   return RichText(
     text: TextSpan(
       text: "¡hal",
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
           text: "!",
           style: TextStyle(
             fontWeight: FontWeight.bold,
             color: Colors.black87,
           ),
         )
       ],
     ),
   );
 }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}