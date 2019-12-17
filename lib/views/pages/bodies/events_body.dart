import 'package:flutter/material.dart';
import 'package:haleo_app/models/perimeter.dart';

import '../../../providers/events_provider.dart';
import '../event_admin_page.dart';
import '../../custom_icons.dart';
import '../../../models/event.dart';
import '../../common_widgets.dart';

class EventsBody extends StatefulWidget {
  @override
  _EventsBodyState createState() => _EventsBodyState();
}

class _EventsBodyState extends State<EventsBody> {

  String eventKey;

  @override
  Widget build(BuildContext context) {
    EventsProvider.eventsBloc(context).perimeterSink.add(Perimeter(lat: 10.0, lng: 10.0, radius: 10.0));
    return StreamBuilder(
      stream: EventsProvider.eventsBloc(context).eventsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          final List<String> sorted = List()..addAll(events.keys)
            ..sort((String a, String b) => a.compareTo(b));
          if (eventKey == null && sorted.isNotEmpty)
            eventKey = sorted.first;
          return Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: EventStack(
                    eventKey: eventKey,
                    events: events,
                  ),
                ),
                EventActions(eventKey),
              ],
            ),
          );
        } else return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }
}

class EventStack extends StatelessWidget {
  final Map<String, Event> events;
  final String eventKey;

  EventStack({
    @required this.events,
    @required this.eventKey,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        children: <Widget>[
          BackgroundCard(
            colorA: 0xfffa6b40,
            colorB: 0xfffd1d1d,
            rotation: height > 400 ? 3.0 : 2.0,
          ),
          BackgroundCard(
            colorA: 0xff7474bf,
            colorB: 0xff348ac7,
            rotation: height > 400 ? -2.0 : -1.0,
          ),
          events.isNotEmpty
          ? EventCard(event: events[eventKey])
          : BackgroundCard(
            colorA: 0xffffff,
            colorB: 0xffffff,
            child: Center(
              child: Text(
                "No hay eventos...",
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class EventActions extends StatelessWidget {
  final String eventKey;

  EventActions(this.eventKey);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 64.0,
            width: 80.0,
            child: FloatingActionButton(
              heroTag: null, // Fixes issue.
              shape: TearBorder(),
              backgroundColor: Colors.white,
              child: Padding(
                // Displace the icon within the button.
                padding: const EdgeInsets.only(right: 12.0),
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
            width: 50.0,
            child: FloatingActionButton(
              heroTag: null, // Fixes issue.
              backgroundColor: Colors.white,
              child: PaintGradient(
                child: Icon(CustomIcons.plus_1),
                colorA: Color(0xff7474bf),
                colorB: Color(0xff348ac7),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EventAdminPage(),
                  ),
                );
              },
            ),
          ),
          Container(
            height: 64.0,
            width: 80.0,
            child: MirrorWidget(
              child: FloatingActionButton(
                heroTag: null, // Fixes issue.
                shape: TearBorder(),
                backgroundColor: Colors.white,
                child: Padding(
                  // Displace the icon within the button.
                  padding: const EdgeInsets.only(right: 12.0),
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
      ),
    );
  }
}