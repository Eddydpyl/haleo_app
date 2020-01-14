import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:angles/angles.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_advanced_networkimage/transition.dart';
import 'package:share/share.dart';

import '../models/user.dart';
import '../models/event.dart';
import '../localization.dart';

class InitialsText extends StatelessWidget {
  final String text;
  final double size;

  InitialsText(this.text, [this.size = 14.0]);

  @override
  Widget build(BuildContext context) {
    return Text(
      text.length >= 2
          ? text.substring(0, 2).toUpperCase()
          : text.toUpperCase(),
      style: TextStyle(color: Colors.red, fontSize: size),
    );
  }
}

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
  final String asset;
  final double height;
  final double width;

  CardImage({
    this.image,
    this.asset = "assets/images/placeholder.jpg",
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
              asset,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
            loadingWidget: Image.asset(
              asset,
              height: height,
              width: width,
              fit: BoxFit.cover,
            ),
          )
        : Image.asset(
            asset,
            height: height,
            width: width,
            fit: BoxFit.cover,
          );
  }
}

class FadeRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  FadeRoute(this.page)
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) =>
              page,
          transitionsBuilder: (BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                  Widget child) =>
              FadeTransition(opacity: animation, child: child),
        );
}

class EventCard extends StatelessWidget {
  final Localization localization;
  final Map<String, User> users;
  final String eventKey;
  final Event event;
  final double height;
  final double width;
  final bool showCount;

  EventCard({
    @required this.localization,
    @required this.users,
    @required this.eventKey,
    @required this.event,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
    this.showCount = true,
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
          return Container(
            height: height,
            width: width,
            child: Stack(
              children: <Widget>[
                Card(
                  shape: ContinuousRectangleBorder(),
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CardImage(
                        image: event.image,
                        asset: randomImage(event.name),
                        height: height > 300 ? height / 2 : height / 4,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 64.0, horizontal: 12.0),
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
                                SizedBox(height: 12.0),
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
                            Share.share(localization.shareText(event.name,
                                event.description)); // TODO: Google Play link.
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.only(top: height > 300
                        ? height / 2 - 32 : height / 4 - 16),
                    child: IgnorePointer(child: userRow()),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget userRow() {
    List<Widget> avatars = List();
    List<String> keys = List.from(event.attendees)..remove(event.user);

    if (keys.isNotEmpty) {
      // Add the first attendee (excluding the organizer).
      if (keys.length <= 2) avatars.add(userAvatar(users[keys[0]], 48.0));
      else avatars.add(userAvatar(users[keys[0]], 32.0));
      // Add the second attendee (excluding the organizer).
      if (keys.length > 2) avatars.add(userAvatar(users[keys[1]], 48.0));
    }

    // Add the event organizer in the centre (if present).
    if (event.attendees.contains(event.user))
      avatars.add(userAvatar(users[event.user], 64.0));

    if (keys.isNotEmpty) {
      // Add the third attendee (excluding the organizer).
      if (keys.length == 2) avatars.add(userAvatar(users[keys[1]], 48.0));
      else if (keys.length > 2) avatars.add(userAvatar(users[keys[2]], 48.0));
      // Add the fourth attendee (excluding the organizer).
      if (keys.length > 3) avatars.add(userAvatar(users[keys[3]], 32.0));
    }

    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: avatars,
        ),
        showCount ? Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            localization.attendeesText(event.slots, event.count),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
            textAlign: TextAlign.center,
          ),
        ) : Container(),
      ],
    );
  }

  Widget userAvatar(User user, double size) {
    return (user?.image?.isNotEmpty ?? false)
        ? CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.white,
            child: TransitionToImage(
              width: double.maxFinite,
              height: double.maxFinite,
              fit: BoxFit.cover,
              borderRadius: BorderRadius.circular(22.0),
              placeholder: InitialsText(user.name),
              loadingWidget: InitialsText(user.name),
              image: AdvancedNetworkImage(
                user.image,
                useDiskCache: true,
                timeoutDuration: Duration(seconds: 5),
              ),
            ),
          )
        : CircleAvatar(
            radius: size / 2,
            backgroundColor: Colors.white,
            child: InitialsText(user?.name ?? "XX"),
          );
  }

  String randomImage(String eventName) {
    int assetNumber = eventName.length % 7;
    String asset = "assets/images/event_" + assetNumber.toString() + ".png";
    return asset;
  }
}

class EmptyCard extends StatelessWidget {
  final Localization localization;

  EmptyCard(this.localization);

  @override
  Widget build(BuildContext context) {
    return ColoredCard(
      colorA: 0xffffff,
      colorB: 0xffffff,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset("assets/images/hangout.png"),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              localization.eventEmptyReadText(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
