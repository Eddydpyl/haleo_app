import 'dart:collection';

import 'package:angles/angles.dart';
import 'package:flutter/material.dart';
import 'package:align_positioned/align_positioned.dart';

import '../../../providers/application_provider.dart';
import '../../../providers/perimeter_events_provider.dart';
import '../../../blocs/perimeter_events_bloc.dart';
import '../../../models/event.dart';
import '../../../models/perimeter.dart';
import '../../../models/user.dart';
import '../../common_widgets.dart';
import '../../custom_icons.dart';
import '../event_admin_page.dart';
import '../../../utility.dart';
import '../../../localization.dart';

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
      final eventsBloc = PerimeterEventsProvider.eventsBloc(context);
      // TODO: Use the actual user location & radius.
      eventsBloc.perimeterSink.add(Perimeter(
        lat: 40.4378698,
        lng: -3.8196212,
        radius: double.maxFinite,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final Localization localization = ApplicationProvider.localization(context);
    final PerimeterEventsBloc eventsBloc =
        PerimeterEventsProvider.eventsBloc(context);
    return StreamBuilder(
      stream: eventsBloc.eventsStream,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, Event>> snapshot) {
        if (snapshot.data != null) {
          final Map<String, Event> events = snapshot.data;
          return StreamBuilder(
            stream: eventsBloc.usersStream,
            builder: (BuildContext context,
                AsyncSnapshot<Map<String, User>> snapshot) {
              if (snapshot.data != null) {
                final Map<String, User> users = snapshot.data;
                return EventsHandler(
                  localization: localization,
                  eventsBloc: eventsBloc,
                  events: events,
                  users: users,
                );
              } else
                return Container();
            },
          );
        } else {
          return Center(
            child: const CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class EventsHandler extends StatefulWidget {
  final Localization localization;
  final PerimeterEventsBloc eventsBloc;
  final Map<String, Event> events;
  final Map<String, User> users;

  EventsHandler({
    @required this.localization,
    @required this.eventsBloc,
    @required this.events,
    @required this.users,
  });

  @override
  _EventsHandlerState createState() => _EventsHandlerState();
}

class _EventsHandlerState extends State<EventsHandler> with TickerProviderStateMixin {
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
            widget.eventsBloc.attendSink.add(MapEntry(eventKey, direction));
            events.remove(eventKey);
            if (events.isNotEmpty)
              eventKey = events.keys.first;
            else eventKey = null;
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
    final String next = events.keys.firstWhere((key) =>
        key != eventKey, orElse: () => null);
    Widget backgroundCard = next != null
        ? EventCard(
            localization: widget.localization,
            eventKey: next,
            event: events[next],
            users: widget.users,
          )
        : EmptyCard(widget.localization);
    Widget foregroundCard = eventKey != null
        ? SwipeWrapper(
            animationController: animationController,
            onSwipe: onSwipe,
            direction: direction,
            height: height,
            width: width,
            child: EventCard(
                localization: widget.localization,
                eventKey: eventKey,
                event: events[eventKey],
                users: widget.users),
          )
        : EmptyCard(widget.localization);
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
            localization: widget.localization,
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
      ..sort((String a, String b) => widget.events[b]
          .created.compareTo(widget.events[a].created));
    sorted.forEach((key) => events[key] = widget.events[key]);
    if (events.isNotEmpty) {
      if (eventKey == null || !events.keys.contains(eventKey))
        eventKey = events.keys.first;
    } else eventKey = null;
  }

  void onSwipe(bool direction) {
    setState(() {
      this.direction = direction;
      this.animationController.forward();
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}

class EventActions extends StatelessWidget {
  final Localization localization;
  final void Function(bool) onSwipe;
  final String eventKey;

  EventActions({
    @required this.localization,
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
              heroTag: null,
              // Fixes issue.
              shape: TearBorder(),
              backgroundColor: Colors.white,
              child: Padding(
                // Displace the icon within the button.
                padding: const EdgeInsets.only(right: 12.0),
                child: PaintGradient(
                  child: Icon(CustomIcons.cancel),
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
                child: Icon(CustomIcons.plus),
                colorA: Color(0xff7474bf),
                colorB: Color(0xff348ac7),
              ),
              onPressed: () async {
                Navigator.push(context, FadeRoute<bool>(EventAdminPage()))
                    .then((result) => (result ?? false) ? SnackBarUtility
                    .show(context, localization.eventCreatedText()) : null);
              },
            ),
          ),
          Container(
            height: 64.0,
            width: 80.0,
            child: MirrorWidget(
              child: FloatingActionButton(
                heroTag: null,
                // Fixes issue.
                shape: TearBorder(),
                backgroundColor: Colors.white,
                child: Padding(
                  // Displace the icon within the button.
                  padding: const EdgeInsets.only(right: 12.0),
                  child: PaintGradient(
                    child: MirrorWidget(child: Icon(CustomIcons.ok)),
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
        double speed = details.velocity.pixelsPerSecond.dx;
        if (speed.abs() == 0.0) return;
        onSwipe(speed > 0);
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
