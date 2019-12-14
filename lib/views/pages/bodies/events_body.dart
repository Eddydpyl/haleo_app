import 'package:flutter/material.dart';

import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventsBody extends StatefulWidget {
  @override
  _EventsBodyState createState() => _EventsBodyState();
}

class _EventsBodyState extends State<EventsBody> {

  final Event event = Event(name: "Padel", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce condimentum augue vel vestibulum sodales. Donec consectetur, nisi a fringilla lobortis, arcu leo ultrices nunc, tincidunt interdum ex libero id diam.", image: "https://www.hotelbalnearivichycatalan.cat/uploads/galleries/que-fer/sense-sortir-del-balneari/padel/pista-padel-8.jpg");

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Align(
          alignment: Alignment.topCenter,
          child: Stack(
            children: <Widget>[
              BackgroundCard(
                color: Colors.red,
                height: height - 150, // The floating action buttons always take up the same space.
                width: width - 50, // We have to leave at least some space for the rotated cards.
                rotation: height > 400 ? 3.0 : 2.0, // Rotation is much more apparent in wider screens.
              ),
              BackgroundCard(
                color: Colors.blue,
                height: height - 150, // The floating action buttons always take up the same space.
                width: width - 50, // We have to leave at least some space for the rotated cards.
                rotation: height > 400 ? -5.0 : -3.0, // Rotation is much more apparent in wider screens.
              ),
              EventCard(
                event: event,
                height: height - 150, // The floating action buttons always take up the same space.
                width: width - 50, // We have to leave at least some space for the rotated cards.
              ),
            ],
          ),
        ),
        Container(height: 10.0),
        EventActions(),
      ],
    );
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
              child: Icon(
                Icons.close,
                color: Colors.red,
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
            child: Icon(
              Icons.add,
              color: Colors.blue,
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
                child: Icon(
                  Icons.favorite,
                  color: Colors.green,
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

