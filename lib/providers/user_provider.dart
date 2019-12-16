import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../blocs/user_admin_bloc.dart';
import '../blocs/user_bloc.dart';

class UserProvider extends StatelessWidget {
  final Widget child;
  final DatabaseManager database;
  final String uid;

  UserProvider({
    @required this.child,
    @required this.database,
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBaseProvider.create(
      key: Key("User"),
      inherited: UserInherited(
        child: child,
        blocs: {
          "userBloc": UserBloc(database),
          "userAdminBloc": UserAdminBloc(database),
        },
      ),
      initialize: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserBloc userBloc = blocs["userBloc"];
        userBloc.userKeySink.add(uid);
      },
      update: (Map<String, BaseBloc> blocs, Set<StreamSubscription> subscriptions) {
        UserBloc userBloc = blocs["userBloc"];
        userBloc.userKeySink.add(uid);
      },
    );
  }

  static UserBloc userBloc(BuildContext context) =>
      MultiBaseProvider.bloc<UserInherited>(context, "userBloc");

  static UserAdminBloc userAdminBloc(BuildContext context) =>
      MultiBaseProvider.bloc<UserInherited>(context, "userAdminBloc");

  static PublishSubject<BaseException> exception(BuildContext context) =>
      MultiBaseProvider.exception<UserInherited>(context);
}

// ignore: must_be_immutable
class UserInherited extends MultiBaseInherited {

  UserInherited({
    @required Widget child,
    @required Map<String, BaseBloc> blocs,
  }) : super(child: child, blocs: blocs);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}