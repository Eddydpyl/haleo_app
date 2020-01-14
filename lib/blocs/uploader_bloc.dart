import 'dart:async';

import 'package:darter_base/darter_base.dart';
import 'package:rxdart/rxdart.dart';

import '../managers/storage_manager.dart';
import '../localization.dart';

class UploaderBloc extends BaseBloc {
  final StorageManager _storageManager;
  final Localization _localization;

  LenientSubject<dynamic> _file;
  LenientSubject<String> _path;
  LenientSubject<String> _delete;

  // Indicates that the image is being uploaded.
  static final String uploading = "UPLOADING";

  UploaderBloc(StorageManager storageManager, Localization localization)
      : _storageManager = storageManager, _localization = localization;

  /// Returns a [Stream] of the path of the latest file to be uploaded.
  Observable<String> get pathStream => _path.stream;

  /// Consumes a file as a [List] of bytes and uploads it.
  Sink<dynamic> get fileSink => _file.sink;

  /// Consumes the path of a file and deletes it.
  Sink<String> get deleteSink => _delete.sink;

  @override
  void initialize() {
    super.initialize();
    _file = LenientSubject(ignoreRepeated: false);
    _path = LenientSubject(ignoreRepeated: false);
    _delete = LenientSubject(ignoreRepeated: false);

    _file.stream.listen((dynamic file) async {
      if (file != null) {
        _path.add(uploading);
        await _storageManager.uploadImage(file)
            .then((String path) => _path.add(path))
            .catchError((e) {
              _path.add(null); // Failed to upload.
              forwardException(e is BaseException ? e
                  : FailedException(_localization.uploadErrorText()));
            });
      }
    });
    _delete.stream.listen((String path) {
      if (path != null) {
        _storageManager.deleteFile(path)
            .catchError((e) => forwardException(e));
      }
    });
  }

  @override
  Future dispose() async {
    List<Future> futures = List();
    futures.add(_file.close());
    futures.add(_path.close());
    futures.add(_delete.close());
    futures.add(super.dispose());
    return Future.wait(futures);
  }
}