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
    @required this.height,
    @required this.width,
    this.rotation = 0.0,
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
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TransitionToImage(
                height: height > 400 ? height / 2 : height / 4,
                width: double.maxFinite,
                fit: BoxFit.cover,
                image: AdvancedNetworkImage(
                  event.image,
                  useDiskCache: true,
                  timeoutDuration: Duration(seconds: 5),
                ),
                placeholder: Container(),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
                child: Text(
                  event.name.toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 8.0),
                    child: Text(
                      event.description,
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 15.0,
                        color: Colors.grey,
                      ),
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
  }
}

class BackgroundCard extends StatelessWidget {
  final Color color;
  final double height;
  final double width;
  final double rotation;

  BackgroundCard({
    @required this.color,
    @required this.height,
    @required this.width,
    this.rotation = 0.0,
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
          color: color,
          child: Container(),
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
  final double tailMultiplier = 1.10;

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
          rect.right * tailMultiplier, rect.top + rect.height / 2.0)
      ..quadraticBezierTo(rect.left + rect.width / 1.5, rect.top + rect.height,
          rect.left + rect.width / 2.0, rect.bottom)
      ..arcToPoint(Offset(rect.left, rect.top + rect.height / 2.0),
          radius: Radius.circular(25.0))
      ..arcToPoint(Offset(rect.left + rect.width / 2.0, rect.top),
          radius: Radius.circular(25.0))
      ..close();
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection textDirection}) {}

  @override
  ShapeBorder scale(double t) {
    return null; // This border doesn't support scaling.
  }
}
