import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/auth_manager.dart';
import '../managers/message_manager.dart';
import '../blocs/state_bloc.dart';

class StateProvider extends StatelessWidget {
  final Widget child;
  final AuthManager auth;
  final DatabaseManager database;
  final MessageManager messaging;

  StateProvider({
    @required this.child,
    @required this.auth,
    @required this.database,
    @required this.messaging,
  });

  @override
  Widget build(BuildContext context) {
    return BaseProvider.create(
      key: Key("State"),
      inherited: StateInherited(
        child: child,
        bloc: StateBloc(auth, database, messaging),
      ),
    );
  }

  static StateBloc stateBloc(BuildContext context) =>
      BaseProvider.bloc<StateInherited>(context);

  static PublishSubject<BaseException> exception(BuildContext context) =>
      BaseProvider.exception<StateInherited>(context);
}

// ignore: must_be_immutable
class StateInherited extends BaseInherited<StateBloc> {

  StateInherited({
    @required Widget child,
    @required StateBloc bloc,
  }) : super(child: child, bloc: bloc);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}