import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/user_events_bloc.dart';
import '../blocs/user_bloc.dart';

class UserEventsProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;

  UserEventsProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("UserEvents"),
      inherited: UserEventsInherited(
        child: child,
        blocs: {
          "eventsBloc": UserEventsBloc(database),
          "userBloc": UserBloc(database),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserEventsBloc eventsBloc = blocs["eventsBloc"];
        UserBloc userBloc = blocs["userBloc"];
        subscriptions.add(stateBloc.userKeyStream.listen((key) {
          eventsBloc.userKeySink.add(key);
          userBloc.userKeySink.add(key);
        }));
      },
    );
  }

  static UserEventsBloc eventsBloc(BuildContext context) =>
      MultiBaseProvider.bloc<UserEventsInherited>(context, "eventsBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<UserEventsInherited>(context, "userBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<UserEventsInherited>(context);
}

// ignore: must_be_immutable
class UserEventsInherited extends MultiBaseInherited {

  UserEventsInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}