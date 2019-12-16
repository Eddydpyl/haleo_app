import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

import '../../../providers/events_provider.dart';
import '../../../models/user.dart';
import '../../custom_icons.dart';
import '../../common_widgets.dart';

class EventsBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: EventsProvider.userBloc(context).userStream,
      builder: (BuildContext context,
          AsyncSnapshot<MapEntry<String, User>> snapshot) {
        if (snapshot.data != null) {
          final User user = snapshot.data.value;
          return AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            leading: PaintGradient(
                child: Icon(CustomIcons.chat),
                colorA: Color(0xfffa6b40),
                colorB: Color(0xfffd1d1d)),
            centerTitle: true,
            title: RichText(
              text: TextSpan(
                text: "¡hal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
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
                      )),
                  TextSpan(
                      text: "!",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ))
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
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Color(0xfffa6b40), Color(0xfffd1d1d)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: (user.image?.isNotEmpty ?? false)
                      ? CircleAvatar(
                          radius: 22.0,
                          backgroundColor: Colors.white,
                          child: TransitionToImage(
                            fit: BoxFit.cover,
                            borderRadius: BorderRadius.circular(22.0),
                            image: AdvancedNetworkImage(
                              user.image,
                              useDiskCache: true,
                              timeoutDuration: Duration(seconds: 5),
                            ),
                            placeholder: InitialsText(user.name),
                            loadingWidget: InitialsText(user.name),
                          ),
                        )
                      : CircleAvatar(
                          radius: 22.0,
                          backgroundColor: Colors.white,
                          child: InitialsText(user.name),
                        ),
                ),
              ),
            ],
          );
        } else
          return Container();
      },
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
