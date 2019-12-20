import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../blocs/state_bloc.dart';
import '../blocs/event_bloc.dart';
import '../blocs/message_admin_bloc.dart';
import '../blocs/user_bloc.dart';

class ChatProvider extends StatelessWidget {
  final Widget child;
  final StateBloc stateBloc;
  final DatabaseManager database;
  final String eventKey;

  ChatProvider({
    @required this.child,
    @required this.stateBloc,
    @required this.database,
    @required this.eventKey,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("Chat"),
      inherited: ChatInherited(
        child: child,
        blocs: {
          "eventBloc": EventBloc(database),
          "messageAdminBloc": MessageAdminBloc(database),
          "userBloc": UserBloc(database),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserBloc userBloc = blocs["userBloc"];
        EventBloc eventBloc = blocs["eventBloc"];
        MessageAdminBloc messageAdminBloc = blocs["messageAdminBloc"];
        eventBloc.eventKeySink.add(eventKey);
        messageAdminBloc.eventKeySink.add(eventKey);
        subscriptions.add(stateBloc.userKeyStream
            .listen((key) => userBloc.userKeySink.add(key)));
      },
      update: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        EventBloc eventBloc = blocs["eventBloc"];
        MessageAdminBloc messageAdminBloc = blocs["messageAdminBloc"];
        eventBloc.eventKeySink.add(eventKey);
        messageAdminBloc.eventKeySink.add(eventKey);
      },
    );
  }

  static EventBloc eventBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ChatInherited>(context, "eventBloc");

  static MessageAdminBloc messageAdminBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ChatInherited>(context, "messageAdminBloc");

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<ChatInherited>(context, "userBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<ChatInherited>(context);
}

// ignore: must_be_immutable
class ChatInherited extends MultiBaseInherited {

  ChatInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}