import 'package:flutter/material.dart';

import '../../custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventsBody extends StatefulWidget {
  @override
  _EventsBodyState createState() => _EventsBodyState();
}

class _EventsBodyState extends State<EventsBody> {
  final Event event = Event(
    name: "Padel",
    description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. "
        "Fusce condimentum augue vel vestibulum sodales. Donec consectetur, "
        "nisi a fringilla lobortis, arcu leo ultrices nunc, tincidunt "
        "interdum ex libero id diam.",
    image: "https://www.hotelbalnearivichycatalan.cat/uploads/galleries/que"
        "-fer/sense-sortir-del-balneari/padel/pista-padel-8.jpg",
  );

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final offsetWidth = 32;
    final offsetHeight = 0.28 * height;

    return Padding(
        padding: new EdgeInsets.only(top: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  BackgroundCard(
                    colorA: 0xfffa6b40,
                    colorB: 0xfffd1d1d,
                    // The floating action buttons always take up the same space.
                    height: height - offsetHeight,
                    // We have to leave at least some space for the rotated cards.
                    width: width - offsetWidth,
                    // Rotation is much more apparent in wider screens.
                    rotation: height > 400 ? 3.0 : 2.0,
                  ),
                  BackgroundCard(
                    colorA: 0xff7474bf,
                    colorB: 0xff348ac7,
                    // The floating action buttons always take up the same space.
                    height: height - offsetHeight,
                    // We have to leave at least some space for the rotated cards.
                    width: width - offsetWidth,
                    // Rotation is much more apparent in wider screens.
                    rotation: height > 400 ? -2.0 : -1.0,
                  ),
                  EventCard(
                    event: event,
                    // The floating action buttons always take up the same space.
                    height: height - offsetHeight,
                    // We have to leave at least some space for the rotated cards.
                    width: width - offsetWidth,
                  ),
                ],
              ),
            ),
            Container(height: 16.0), // Acts as padding here
            Expanded(child: EventActions()),
            Container(height: 16.0), // Acts as padding here
          ],
        ));
  }
}

class EventActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50.0,
          child: FloatingActionButton(
            shape: TearBorder(),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: PaintGradient(
                child: Icon(CustomIcons.cancel_1),
                colorA: Color(0xfffa6b40),
                colorB: Color(0xfffd1d1d),
              ),
            ),
            onPressed: () {
              // TODO
            },
          ),
        ),
        Container(
          height: 50.0,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            child: PaintGradient(
              child: Icon(CustomIcons.plus_1),
              colorA: Color(0xff7474bf),
              colorB: Color(0xff348ac7),
            ),
            onPressed: () {
              // TODO
            },
          ),
        ),
        Container(
          height: 50.0,
          child: MirrorWidget(
            child: FloatingActionButton(
              shape: TearBorder(),
              backgroundColor: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: PaintGradient(
                  child: Icon(CustomIcons.heart_filled),
                  colorA: Color(0xff7dd624),
                  colorB: Color(0xff45b649),
                ),
              ),
              onPressed: () {
                // TODO
              },
            ),
          ),
        ),
      ],
    );
  }
}
