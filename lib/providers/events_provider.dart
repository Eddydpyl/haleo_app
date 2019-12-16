import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/preference_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/events_bloc.dart';
import '../blocs/user_bloc.dart';
import '../localization.dart';

class EventsProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;
  final PreferenceManager preferences;
  final Localization localization;

  EventsProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
    @required this.preferences,
    @required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("Events"),
      inherited: EventsInherited(
        child: child,
        blocs: {
          "eventsBloc": EventsBloc(database, preferences, localization),
          "userBloc": UserBloc(database),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserBloc userBloc = blocs["userBloc"];
        subscriptions.add(stateBloc.userKeyStream
            .listen((key) => userBloc.userKeySink.add(key)));
      },
    );
  }

  static EventsBloc eventsBloc(BuildContext context) =>
      MultiBaseProvider.bloc<EventsInherited>(context, "eventsBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<EventsInherited>(context, "userBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<EventsInherited>(context);
}

// ignore: must_be_immutable
class EventsInherited extends MultiBaseInherited {

  EventsInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}