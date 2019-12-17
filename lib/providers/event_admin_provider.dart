import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../localization.dart';
import '../managers/database_manager.dart';
import '../managers/storage_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/event_admin_bloc.dart';
import '../blocs/uploader_bloc.dart';
import '../blocs/user_bloc.dart';

class EventAdminProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;
  final StorageManager storage;
  final Localization localization;

  EventAdminProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
    @required this.storage,
    @required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("EventAdmin"),
      inherited: EventAdminInherited(
        child: child,
        blocs: {
          "eventAdminBloc": EventAdminBloc(database),
          "uploaderBloc": UploaderBloc(storage, localization),
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

  static EventAdminBloc eventAdminBloc(BuildContext context) =>
      MultiBaseProvider.bloc<EventAdminInherited>(context, "eventAdminBloc");

  static UploaderBloc uploaderBloc(BuildContext context) =>
      MultiBaseProvider.bloc<EventAdminInherited>(context, "uploaderBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<EventAdminInherited>(context, "userBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<EventAdminInherited>(context);
}

// ignore: must_be_immutable
class EventAdminInherited extends MultiBaseInherited {

  EventAdminInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}