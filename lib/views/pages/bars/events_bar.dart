import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../../models/user.dart';

class EventsBar extends StatelessWidget implements PreferredSizeWidget {

  final AppUser user = AppUser(name: "Barto");

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.0,
      leading: Icon(
        Icons.chat_bubble,
        color: Colors.red,
      ),
      centerTitle: true,
      title: RichText(
        text: TextSpan(
          text: "hal",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 35.0,
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
          ],
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
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: (user.image?.isNotEmpty ?? false)
              ? CircleAvatar(
                radius: 22.0,
                backgroundColor: Colors.white,
                child: TransitionToImage(
                  fit: BoxFit.cover,
                  image: AdvancedNetworkImage(
                    user.image,
                    useDiskCache: true,
                    timeoutDuration: Duration(seconds: 5),
                  ),
                  placeholder: InitialsText(user.name),
                ),
              ) : CircleAvatar(
                radius: 22.0,
                backgroundColor: Colors.white,
                child: InitialsText(user.name),
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

