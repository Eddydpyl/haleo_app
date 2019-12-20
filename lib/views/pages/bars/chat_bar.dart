import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../../providers/events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class ChatBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: PaintGradient(
          child: IconButton(
            icon: Icon(CustomIcons.left_big),
            onPressed: () {},
          ),
          colorA: Color(0xfffa6b40),
          colorB: Color(0xfffd1d1d)),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: "Event Name",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF424242),
            fontSize: 35.0,
          )
        ),
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Container(
            width: 32.0,
            height: 32.0,
            padding: const EdgeInsets.all(2.0),
            decoration: new BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xfffa6b40), Color(0xfffd1d1d)],
              ),
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 22.0,
              backgroundColor: Colors.white,
              child: InitialsText('Miguel Esteban'),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class InitialsText extends StatelessWidget {
  final String text;

  InitialsText(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.length >= 2
          ? text.substring(0, 2).toUpperCase()
          : text.toUpperCase(),
      style: TextStyle(color: Colors.red),
    );
  }
}
