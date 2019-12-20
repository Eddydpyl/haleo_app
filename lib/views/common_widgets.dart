import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:angles/angles.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';

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

class ColoredCard extends StatelessWidget {
  final int colorA;
  final int colorB;
  final double height;
  final double width;
  final double rotation;
  final Widget child;

  ColoredCard({
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

class CardImage extends StatelessWidget {
  final String image;
  final double height;
  final double width;

  CardImage({
    this.image,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
  });

  @override
  Widget build(BuildContext context) {
    return (image?.isNotEmpty ?? false)
      ? TransitionToImage(
        height: height,
        width: width,
        fit: BoxFit.cover,
        image: AdvancedNetworkImage(
          image,
          useDiskCache: true,
          timeoutDuration: Duration(seconds: 5),
        ),
        placeholder: Image.asset(
          "assets/images/placeholder.jpg",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
        loadingWidget: Image.asset(
          "assets/images/placeholder.jpg",
          height: height,
          width: width,
          fit: BoxFit.cover,
        ),
      ) : Image.asset(
        "assets/images/placeholder.jpg",
        height: height,
        width: width,
        fit: BoxFit.cover,
      );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute(this.page) : super(
    pageBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation) => page,
    transitionsBuilder: (BuildContext context, Animation<double> animation,
        Animation<double> secondaryAnimation, Widget child) =>
        FadeTransition(opacity: animation, child: child),
  );
}
