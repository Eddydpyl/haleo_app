import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/session_provider.dart';
import '../../../blocs/session_bloc.dart';
import '../../../localization.dart';

class SessionBody extends StatefulWidget {
  @override
  _SessionBodyState createState() => _SessionBodyState();
}

class _SessionBodyState extends State<SessionBody> {
  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    final SessionBloc sessionBloc = SessionProvider.sessionBloc(context);
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xfffa6b40), Color(0xfffd1d1d)],
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: height <= 400.0 ? height - 210 : height / 3,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    localization.haleoText(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50.0,
                    ),
                  ),
                  Text(
                    localization.promoText(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: buttonStack(localization, sessionBloc, height, width),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buttonStack(Localization localization,
      SessionBloc sessionBloc, double height, double width) {
    if (height <= 400.0) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            BgLoginCard(height: 180, radius: 16.0),
            BgLoginCard(height: 160, radius: 16.0),
            BgLoginCard(height: 140, radius: 16.0, color: Colors.white),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                signInText(localization),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      googleButton(sessionBloc),
                      facebookButton(sessionBloc),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    } else {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            BgLoginCard(height: ((7 * height) / 12) - 20, radius: 16.0),
            BgLoginCard(height: ((7 * height) / 12) - 40, radius: 16.0),
            BgLoginCard(height: ((7 * height) / 12) - 60, radius: 16.0),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                signInText(localization),
                Container(height: 8.0),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: googleButton(sessionBloc),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: facebookButton(sessionBloc),
                ),
                SizedBox(
                  height: 16.0,
                )
              ],
            ),
          ],
        ),
      );
    }
  }

  Widget signInText(Localization localization) {
    return Text(
      localization.signInText(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black54,
        fontSize: 30.0,
      ),
    );
  }

  Widget googleButton(SessionBloc sessionBloc) {
    return LoginButton(
      text: "Google",
      padding: EdgeInsets.symmetric(vertical: 12.0),
      backgroundColor: Colors.red,
      icon: FontAwesomeIcons.google,
      onPressed: () => sessionBloc.googleSink.add(true),
    );
  }

  Widget facebookButton(SessionBloc sessionBloc) {
    return LoginButton(
      text: "Facebook",
      padding: EdgeInsets.symmetric(vertical: 12.0),
      backgroundColor: Colors.blue[700],
      icon: FontAwesomeIcons.facebookF,
      onPressed: () => sessionBloc.facebookSink.add(true),
    );
  }

  Widget emailButton(SessionBloc sessionBloc) {
    return LoginButton(
      text: "Email",
      padding: EdgeInsets.symmetric(vertical: 12.0),
      backgroundColor: Colors.grey,
      icon: FontAwesomeIcons.envelope,
      onPressed: () {
        // TODO
      },
    );
  }
}

class LoginButton extends StatelessWidget {
  final IconData icon;
  final Widget image;
  final double fontSize;
  final Color textColor, iconColor, backgroundColor, splashColor;
  final Function onPressed;
  final String text;
  final EdgeInsets padding, innerPadding;
  final double elevation;
  final double height;
  final double width;

  LoginButton({
    Key key,
    @required this.onPressed,
    @required this.text,
    @required this.backgroundColor,
    this.fontSize = 14.0,
    this.elevation = 2.0,
    this.textColor = Colors.white,
    this.iconColor = Colors.white,
    this.splashColor = Colors.white30,
    this.innerPadding,
    this.padding,
    this.height,
    this.width,
    this.icon,
    this.image,
  })  : assert(text != null),
        assert(icon != null || image != null),
        assert(backgroundColor != null),
        assert(onPressed != null),
        assert(elevation != null);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      key: key,
      minWidth: 35.0,
      height: height,
      elevation: elevation,
      padding: padding ?? EdgeInsets.all(0),
      color: backgroundColor,
      onPressed: onPressed,
      splashColor: splashColor,
      child: Container(
        constraints: BoxConstraints(maxWidth: width ?? 220),
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: innerPadding ?? EdgeInsets.symmetric(horizontal: 13),
                child: getIconOrImage(),
              ),
              Text(
                text,
                style: TextStyle(
                  fontFamily: "Roboto",
                  color: textColor,
                  fontSize: fontSize,
                  backgroundColor: Color.fromRGBO(0, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getIconOrImage() {
    if (image != null)
      return image;
    return Icon(
      icon,
      size: 20,
      color: this.iconColor,
    );
  }
}

class BgLoginCard extends StatelessWidget {
  final double height;
  final double radius;
  final Color color;

  BgLoginCard({
    @required this.height,
    @required this.radius,
    this.color = Colors.white54,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
    );
  }
}
