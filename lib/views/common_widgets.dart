import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:angles/angles.dart';
import 'package:share/share.dart';

import '../models/event.dart';

class PaintGradient extends StatelessWidget {
  final Widget child;
  final Color colorA;
  final Color colorB;

  PaintGradient({
    @required this.child,
    @required this.colorA,
    @required this.colorB,
  });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: child,
      blendMode: BlendMode.srcIn,
      shaderCallback: (Rect bounds) {
        return ui.Gradient.linear(
          Offset(4.0, 24.0),
          Offset(24.0, 4.0),
          [colorA, colorB],
        );
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final Event event;
  final double height;
  final double width;
  final double rotation;

  EventCard({
    @required this.event,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.rotation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;
          return Transform.rotate(
            angle: Angle.fromDegrees(rotation).radians,
            child: Container(
              height: height,
              width: width,
              child: Card(
                shape: ContinuousRectangleBorder(),
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TransitionToImage(
                      height: height > 300 ? height / 2 : height / 4,
                      width: double.maxFinite,
                      fit: BoxFit.cover,
                      image: AdvancedNetworkImage(
                        event.image,
                        useDiskCache: true,
                        timeoutDuration: Duration(seconds: 5),
                      ),
                      placeholder: Image.asset("assets/images/placeholder.jpg"),
                      loadingWidget: Image.asset("assets/images/placeholder.jpg"),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                event.name.toUpperCase(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Colors.black87,
                                ),
                              ),
                              Container(height: 12.0),
                              Text(
                                event.description,
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.0,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FlatButton(
                        shape: CircleBorder(),
                        child: PaintGradient(
                          child: Icon(Icons.share),
                          colorA: Color(0xff7474bf),
                          colorB: Color(0xff348ac7),
                        ),
                        onPressed: () {
                          Share.share("Que Haleo más grande.");
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class BackgroundCard extends StatelessWidget {
  final int colorA;
  final int colorB;
  final double height;
  final double width;
  final double rotation;
  final Widget child;

  BackgroundCard({
    @required this.colorA,
    @required this.colorB,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.rotation = 0.0,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: Angle.fromDegrees(rotation).radians,
      child: Container(
        height: height,
        width: width,
        child: Card(
          shape: ContinuousRectangleBorder(),
          child: Container(
            child: child ?? Container(),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(colorA), Color(colorB)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MirrorWidget extends StatelessWidget {
  final Widget child;

  MirrorWidget({@required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.001)
        ..rotateX(0.0)
        ..rotateY(Angle.fromDegrees(180).radians),
      alignment: FractionalOffset.center,
      child: child,
    );
  }
}

class TearBorder extends ShapeBorder {
  const TearBorder();

  @override
  EdgeInsetsGeometry get dimensions {
    return const EdgeInsets.only();
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  Path getOuterPath(Rect rect, {TextDirection textDirection}) {
    return Path()
      ..moveTo(rect.left + rect.width / 2.0, rect.top)
      ..quadraticBezierTo(rect.left + rect.width / 1.5, rect.top,
          rect.width, rect.top + rect.height / 2.0)
      ..quadraticBezierTo(rect.left + rect.width / 1.5, rect.top + rect.height,
          rect.left + rect.width / 2.0, rect.bottom)
      ..arcToPoint(Offset(rect.left, rect.top + rect.height / 2.0),
          radius: Radius.circular(rect.height / 2))
      ..arcToPoint(Offset(rect.left + rect.width / 2.0, rect.top),
          radius: Radius.circular(rect.height / 2))
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null; // This border doesn't support scaling.
  }
}
