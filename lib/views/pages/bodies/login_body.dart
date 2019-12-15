import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginBody extends StatefulWidget {
  @override
  _LoginBodyState createState() => _LoginBodyState();
}

class _LoginBodyState extends State<LoginBody> {
  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;

    return Stack(children: <Widget>[
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffa6b40), Color(0xfffd1d1d)]),
        ),
      ),
      Positioned.fill(
        top: height / 4,
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RichText(
                maxLines: 1,
                textAlign: TextAlign.center,
                text: TextSpan(
                    text: "¡haleo!",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 50.0,
                    )),
              ),
              Padding(
                padding: EdgeInsets.all(32.0),
                child: RichText(
                  maxLines: 4,
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      text: "Encuentra eventos cerca de ti. \n ¡Estás a un click!",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 20.0,
                      )),
                ),
              )
            ]),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(children: <Widget>[
            BgLoginCard(height: 320, radius: 16.0),
            BgLoginCard(height: 340, radius: 16.0),
            BgLoginCard(height: 300, radius: 16.0, color: Colors.white),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 300,
                    child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                          Padding(
                              padding: EdgeInsets.only(bottom: 16.0),
                              child: RichText(
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    text: "¡padentro!",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54,
                                      fontSize: 30.0,
                                    )),
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: LoginButton(
                                text: 'Google',
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                backgroundColor: Colors.red,
                                icon: FontAwesomeIcons.google,
                                onPressed: () => {},
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: LoginButton(
                                text: 'Facebook',
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                backgroundColor: Colors.blue[700],
                                icon: FontAwesomeIcons.facebookF,
                                onPressed: () => {},
                              )),
                          Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: LoginButton(
                                text: 'Email',
                                padding: EdgeInsets.symmetric(vertical: 12.0),
                                backgroundColor: Colors.grey,
                                icon: FontAwesomeIcons.envelope,
                                onPressed: () => {},
                              )),
                        ])))),
          ])),
    ]);
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

  LoginButton(
      {Key key,
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
      this.image})
      : assert(text != null),
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
      child: _getButtonChild(context),
    );
  }

  /// Get the inner content of a button
  Container _getButtonChild(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxWidth: width ?? 220,
      ),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: innerPadding ??
                  EdgeInsets.symmetric(
                    horizontal: 13,
                  ),
              child: _getIconOrImage(),
            ),
            Text(
              text,
              style: TextStyle(
                fontFamily: 'Roboto',
                color: textColor,
                fontSize: fontSize,
                backgroundColor: Color.fromRGBO(0, 0, 0, 0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Get the icon or image widget
  Widget _getIconOrImage() {
    if (image != null) {
      return image;
    }
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
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius))),
        ));
  }
}
