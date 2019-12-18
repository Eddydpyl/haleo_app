import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/events_provider.dart';
import '../../../blocs/events_bloc.dart';
import '../../../localization.dart';
import '../../../models/event.dart';
import '../../../models/perimeter.dart';
import '../../../utility.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../event_admin_page.dart';

class EventsBody extends StatefulWidget {
  @override
  _EventsBodyState createState() => _EventsBodyState();
}

class _EventsBodyState extends State<EventsBody> {

  String eventKey;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Localization localization = ApplicationProvider.localization(context);
    final EventsBloc eventsBloc = EventsProvider.eventsBloc(context);
    Location().getLocation().then((LocationData location) {
      eventsBloc.perimeterSink.add(Perimeter(
        lat: location.latitude,
        lng: location.longitude,
        // TODO: Use a more reasonable radius.
        radius: double.maxFinite,
      ));
    }).catchError((e) {
      if (e is PlatformException
          && e.code == 'PERMISSION_DENIED') {
        Location().requestPermission();
        SnackBarUtility.show(context,
            localization.locationPermissionText());
      } else {
        SnackBarUtility.show(context,
            localization.locationErrorText());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: EventsProvider.eventsBloc(context).eventsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          final List<String> sorted = List()..addAll(events.keys)
            ..sort((String a, String b) => a.compareTo(b));
          if (sorted.isNotEmpty && (eventKey == null
              || !sorted.contains(eventKey)))
            eventKey = sorted.first;
          return Padding(
            padding: EdgeInsets.only(top: 8.0),
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
    final double width = MediaQuery.of(context).size.width;
    List<Widget> eventCards = [EventCard(eventKey: eventKey,
        event: events[eventKey], height: height, width: width)];
    Map.from(events)..remove(eventKey)..forEach((key, event) =>
        eventCards.add(EventCard(eventKey: key, event: event,
        height: height, width: width)));
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Stack(
        overflow: Overflow.visible,
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
          EmptyCard(),
        ]..addAll(eventCards),
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
            height: 64.0,
            width: 64.0,
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
                  FadeRoute(EventAdminPage()),
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

class EventCard extends StatefulWidget {
  final String eventKey;
  final Event event;
  final double height;
  final double width;

  EventCard({
    @required this.eventKey,
    @required this.event,
    this.height = double.maxFinite,
    this.width = double.maxFinite,
  });

  @override
  _EventCardState createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with TickerProviderStateMixin {
  AnimationController rotationController;
  AnimationController verticalController;
  AnimationController horizontalController;

  Animation<double> rotation;
  Animation<double> vertical;
  Animation<double> horizontal;

  bool direction = true;

  @override
  void initState() {
    super.initState();
    rotationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    verticalController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    horizontalController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )..addListener(() {
      setState(() {});
    });

    horizontalController.addStatusListener((AnimationStatus status) {
      // Release memory when the card is dismissed.
      if (status == AnimationStatus.completed) dispose();
    });

    rotation = Tween<double>(
      begin: 0.0,
      end: 40.0,
    ).animate(
      CurvedAnimation(
        parent: rotationController,
        curve: Curves.ease,
      ),
    );

    vertical = Tween<double>(
      begin: 0.0,
      end: - 100.0,
    ).animate(
      CurvedAnimation(
        parent: verticalController,
        curve: Curves.ease,
      ),
    );

    horizontal = Tween<double>(
      begin: 0.0,
      end: widget.width * 1.5,
    ).animate(
      CurvedAnimation(
        parent: horizontalController,
        curve: Curves.ease,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        direction = details.velocity.pixelsPerSecond.dx > 0;
        rotationController.forward();
        verticalController.forward();
        horizontalController.forward();
      },
      child: AlignPositioned(
        dy: vertical.value,
        dx: direction ? horizontal.value : - horizontal.value,
        child: Transform.rotate(
          angle: Angle.fromDegrees(rotation.value).radians,
          child: Container(
            height: widget.height,
            width: widget.width,
            child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                final double height = constraints.maxHeight;
                final double width = constraints.maxWidth;
                return Container(
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
                        CardImage(
                          image: widget.event.image,
                          height: height > 300 ? height / 2 : height / 4,
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
                                    widget.event.name.toUpperCase(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(height: 12.0),
                                  Text(
                                    widget.event.description,
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
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    rotationController.dispose();
    verticalController.dispose();
    horizontalController.dispose();
  }
}

class EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackgroundCard(
      colorA: 0xffffff,
      colorB: 0xffffff,
      child: Center(
        child: Text(
          "No hay eventos...",
        ),
      ),
    );
  }
}
