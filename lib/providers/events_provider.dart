import 'package:darter_base/darter_base.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/database_manager.dart';
import '../managers/preference_manager.dart';
import '../blocs/events_bloc.dart';
import '../localization.dart';

class EventsProvider extends StatelessWidget {
  final Widget child;
  final DatabaseManager database;
  final PreferenceManager preferences;
  final Localization localization;

  EventsProvider({
    @required this.child,
    @required this.database,
    @required this.preferences,
    @required this.localization,
  });

  @override
  Widget build(BuildContext context) {
    return BaseProvider.create(
      key: Key("Events"),
      inherited: EventsInherited(
        child: child,
        bloc: EventsBloc(database, preferences, localization),
      ),
    );
  }

  static EventsBloc eventsBloc(BuildContext context) =>
      BaseProvider.bloc<EventsInherited>(context);

  static PublishSubject<BaseException> exception(BuildContext context) =>
      BaseProvider.exception<EventsInherited>(context);
}

// ignore: must_be_immutable
class EventsInherited extends BaseInherited<EventsBloc> {

  EventsInherited({
    @required Widget child,
    @required EventsBloc bloc,
  }) : super(child: child, bloc: bloc);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => false;
}