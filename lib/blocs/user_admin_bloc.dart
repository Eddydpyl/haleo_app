import 'dart:async';

import 'package:darter_base/darter_base.dart';

import '../managers/database_manager.dart';
import '../models/user.dart';
import '../localization.dart';

class UserAdminBloc extends BaseBloc {
  final DatabaseManager _databaseManager;
  final Localization _localization;

  LenientSubject<MapEntry<String, User>> _create;
  LenientSubject<MapEntry<String, User>> _update;
  LenientSubject<String> _delete;

  UserAdminBloc(DatabaseManager databaseManager, Localization localization)
      : _databaseManager = databaseManager, _localization = localization;

  /// Consumes a [MapEntry] and uses it to create an instance in the database.
  LenientSink<MapEntry<String, User>> get createSink => _create.sink;

  /// Consumes a [MapEntry] and uses it to update the instance in the database.
  LenientSink<MapEntry<String, User>> get updateSink => _update.sink;

  /// Consumes a [String] and uses it to delete the instance in the database.
  LenientSink<String> get deleteSink => _delete.sink;

  @override
  void initialize() {
    super.initialize();
    _create = LenientSubject(ignoreRepeated: false);
    _update = LenientSubject(ignoreRepeated: false);
    _delete = LenientSubject(ignoreRepeated: false);

    _create.stream.listen((MapEntry<String, User> entry) {
      if (entry != null) {
        _databaseManager.userRepository().create(entry.key, entry.value)
            .catchError((e) => forwardException(e));
      }
    });
    _update.stream.listen((MapEntry<String, User> entry) {
      if (entry != null) {
        _databaseManager.userRepository().update(entry.key, entry.value)
            .then((_) => forwardException(SuccessfulException(_localization.userUpdatedText())))
            .catchError((e) => forwardException(e));
      }
    });
    _delete.stream.listen((String key) {
      if (key?.isNotEmpty ?? false) {
        _databaseManager.userRepository().delete(key)
            .catchError((e) => forwardException(e));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_create.close());
    futures.add(_update.close());
    futures.add(_delete.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}