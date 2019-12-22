import 'dart:collection';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:align_positioned/align_positioned.dart';
import 'package:location/location.dart';
import 'package:share/share.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/perimeter_events_provider.dart';
import '../../../blocs/perimeter_events_bloc.dart';
import '../../../localization.dart';
import '../../../models/event.dart';
import '../../../models/perimeter.dart';
import '../../../utility.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../event_admin_page.dart';

class EventsCardsBody extends StatefulWidget {
  @override
  _EventsCardsBodyState createState() => _EventsCardsBodyState();
}

class _EventsCardsBodyState extends State<EventsCardsBody> {
  bool init = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!init) {
      init = true;
      final Localization localization =
          ApplicationProvider.localization(context);
      final PerimeterEventsBloc eventsBloc =
          PerimeterEventsProvider.eventsBloc(context);
      Location().getLocation().then((LocationData location) {
        eventsBloc.perimeterSink.add(Perimeter(
          lat: location.latitude,
          lng: location.longitude,
          // TODO: Use a more reasonable radius.
          radius: double.maxFinite,
        ));
      }).catchError((e) {
        if (e is PlatformException && e.code == 'PERMISSION_DENIED') {
          Location().requestPermission();
          SnackBarUtility.show(context, localization.locationPermissionText());
        } else {
          SnackBarUtility.show(context, localization.locationErrorText());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final PerimeterEventsBloc eventsBloc =
        PerimeterEventsProvider.eventsBloc(context);
    return StreamBuilder(
      stream: eventsBloc.eventsStream,
      builder:
          (BuildContext context, AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          return EventsHandler(
            eventsBloc: eventsBloc,
            events: events,
          );
        } else
          return Center(
            child: const CircularProgressIndicator(),
          );
      },
    );
  }
}

class EventsHandler extends StatefulWidget {
  final PerimeterEventsBloc eventsBloc;
  final Map<String, Event> events;

  EventsHandler({
    @required this.eventsBloc,
    @required this.events,
  });

  @override
  _EventsHandlerState createState() => _EventsHandlerState();
}

class _EventsHandlerState extends State<EventsHandler>
    with TickerProviderStateMixin {
  AnimationController animationController;
  LinkedHashMap<String, Event> events;
  String eventKey;
  bool direction;

  @override
  void initState() {
    super.initState();
    resetEvents();
    direction = true;
    animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    )
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            events.remove(eventKey);
            if (events.isNotEmpty)
              eventKey = events.keys.first;
            else
              eventKey = null;
            animationController.reset();
          });
        }
      });
  }

  @override
  void didUpdateWidget(EventsHandler oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => resetEvents());
  }

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    final String next =
        events.keys.firstWhere((key) => key != eventKey, orElse: () => null);
    Widget backgroundCard = next != null
        ? EventCard(eventKey: next, event: events[next])
        : EmptyCard();
    Widget foregroundCard = eventKey != null
        ? SwipeWrapper(
            animationController: animationController,
            onSwipe: onSwipe,
            direction: direction,
            height: height,
            width: width,
            child: EventCard(eventKey: eventKey, event: events[eventKey]))
        : EmptyCard();
    return Padding(
      padding: EdgeInsets.only(top: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  ColoredCard(
                    colorA: 0xfffa6b40,
                    colorB: 0xfffd1d1d,
                    rotation: height > 400 ? 3.0 : 2.0,
                  ),
                  ColoredCard(
                    colorA: 0xff7474bf,
                    colorB: 0xff348ac7,
                    rotation: height > 400 ? -2.0 : -1.0,
                  ),
                  backgroundCard,
                  foregroundCard,
                ],
              ),
            ),
          ),
          EventActions(
            onSwipe: onSwipe,
            eventKey: eventKey,
          ),
        ],
      ),
    );
  }

  void resetEvents() {
    events = LinkedHashMap();
    List<String> sorted = List.from(widget.events.keys)
      ..sort((String a, String b) =>
          widget.events[b].created.compareTo(widget.events[a].created));
    sorted.forEach((key) => events[key] = widget.events[key]);
    if (events.isNotEmpty) {
      if (eventKey == null || !events.keys.contains(eventKey))
        eventKey = events.keys.first;
    } else
      eventKey = null;
  }

  void onSwipe(bool direction) {
    setState(() {
      this.direction = direction;
      this.animationController.forward();
      widget.eventsBloc.attendSink.add(MapEntry(eventKey, direction));
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}

class EventActions extends StatelessWidget {
  final void Function(bool) onSwipe;
  final String eventKey;

  EventActions({
    this.onSwipe,
    this.eventKey,
  });

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
              onPressed: () => onSwipe(false),
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
                onPressed: () => onSwipe(true),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SwipeWrapper extends StatelessWidget {
  final AnimationController animationController;
  final void Function(bool) onSwipe;
  final Widget child;
  final bool direction;
  final double height;
  final double width;

  final Animation<double> rotation;
  final Animation<double> vertical;
  final Animation<double> horizontal;

  SwipeWrapper({
    @required this.animationController,
    @required this.onSwipe,
    @required this.child,
    @required this.direction,
    @required this.height,
    @required this.width,
  })  : rotation = Tween<double>(
          begin: 0.0,
          end: 40.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        ),
        vertical = Tween<double>(
          begin: 0.0,
          end: -100.0,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        ),
        horizontal = Tween<double>(
          begin: 0.0,
          end: width * 1.5,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Curves.ease,
          ),
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (DragEndDetails details) {
        bool direction = details.velocity.pixelsPerSecond.dx > 0;
        onSwipe(direction);
      },
      child: AlignPositioned(
        dy: vertical.value,
        dx: direction ? horizontal.value : -horizontal.value,
        child: Transform.rotate(
          angle: Angle.fromDegrees(rotation.value).radians,
          child: child,
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
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
            child: Card(
              shape: ContinuousRectangleBorder(),
              color: Colors.white,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CardImage(
                    image: event.image,
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
                        Share.share("¡Únete a este haleo! : *" +
                            event.name +
                            "* \n _" +
                            event.description +
                            "_  \n ¡Descarga ya la app en Google Play!"); // TODO: google play link
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EmptyCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ColoredCard(
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
