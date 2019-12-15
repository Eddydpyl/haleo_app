import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

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
            image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.black.withOpacity(0.2), BlendMode.dstATop),
                image: NetworkImage(
                    'https://images.unsplash.com/photo-1471421298428-1513ab720a8e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=632&q=80'),
                fit: BoxFit.cover)),
      ),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 128.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: RichText(
              text: TextSpan(
                text: "hal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontSize: 50.0,
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
          )),
      Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Stack(children: <Widget>[
            BgLoginCard(height: 320, radius: 16.0),
            BgLoginCard(height: 340, radius: 16.0),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.white54,
                      borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16.0),
                          topRight: const Radius.circular(16.0))),
                )),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                    height: 300,
                    child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                      SignInButton(
                        Buttons.Google,
                        onPressed: () {}, //TODO: google login
                      ),
                      SignInButton(
                        Buttons.Facebook,
                        onPressed: () {}, //TODO: facebook login
                      ),
                    ])))),
          ])),
    ]);
  }
}

class BgLoginCard extends StatelessWidget {
  final double height;
  final double radius;

  BgLoginCard({
    @required this.height,
    @required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: height,
          decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(radius),
                  topRight: Radius.circular(radius))),
        ));
  }
}
