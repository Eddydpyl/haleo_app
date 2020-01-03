import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../localization.dart';
import '../managers/database_manager.dart';
import '../managers/storage_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/user_events_bloc.dart';
import '../blocs/user_bloc.dart';
import '../blocs/user_admin_bloc.dart';
import '../blocs/uploader_bloc.dart';

class ProfileProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;
  final StorageManager storage;
  final Localization localization;

  ProfileProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
    @required this.storage,
    @required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("Profile"),
      inherited: ProfileInherited(
        child: child,
        blocs: {
          "eventsBloc": UserEventsBloc(database),
          "userBloc": UserBloc(database),
          "userAdminBloc": UserAdminBloc(database, localization),
          "uploaderBloc": UploaderBloc(storage, localization),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserEventsBloc eventsBloc = blocs["eventsBloc"];
        UserBloc userBloc = blocs["userBloc"];
        eventsBloc.openSink.add(true);
        subscriptions.add(stateBloc.userKeyStream.listen((key) {
          eventsBloc.userKeySink.add(key);
          userBloc.userKeySink.add(key);
        }));
      },
    );
  }

  static UserEventsBloc eventsBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ProfileInherited>(context, "eventsBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ProfileInherited>(context, "userBloc");

  static UserAdminBloc userAdminBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ProfileInherited>(context, "userAdminBloc");

  static UploaderBloc uploaderBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ProfileInherited>(context, "uploaderBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<ProfileInherited>(context);
}

// ignore: must_be_immutable
class ProfileInherited extends MultiBaseInherited {

  ProfileInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}