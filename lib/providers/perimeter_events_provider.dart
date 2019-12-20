import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/message_manager.dart';
import '../managers/preference_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/perimeter_events_bloc.dart';
import '../blocs/user_bloc.dart';

class PerimeterEventsProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;
  final MessageManager messaging;
  final PreferenceManager preferences;

  PerimeterEventsProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
    @required this.messaging,
    @required this.preferences,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("PerimeterEvents"),
      inherited: PerimeterEventsInherited(
        child: child,
        blocs: {
          "eventsBloc": PerimeterEventsBloc(database, messaging, preferences),
          "userBloc": UserBloc(database),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        PerimeterEventsBloc eventsBloc = blocs["eventsBloc"];
        UserBloc userBloc = blocs["userBloc"];
        subscriptions.add(stateBloc.userKeyStream.listen((key) {
          eventsBloc.userKeySink.add(key);
          userBloc.userKeySink.add(key);
        }));
      },
    );
  }

  static PerimeterEventsBloc eventsBloc(BuildContext context) =>
      MultiBaseProvider.bloc<PerimeterEventsInherited>(context, "eventsBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<PerimeterEventsInherited>(context, "userBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<PerimeterEventsInherited>(context);
}

// ignore: must_be_immutable
class PerimeterEventsInherited extends MultiBaseInherited {

  PerimeterEventsInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}