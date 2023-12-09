part of 'am_box.dart';

class AMBoxStorage {
  // static final _dBs = <String, AMBoxDB>{};
  final _folders = <String, AMFolder<AMBoxStorage>>{};
  final _files = <String, AMFile<AMBoxStorage>>{};

  final AMApplication parentApp;
  // ignore: unused_element
  String get _id => parentApp._storageFolderID;

  AMBoxStorage(this.parentApp);

  AMFolder<AMBoxStorage> folder(String name) {
    if (_folders[name] != null) return _folders[name]!;
    var folder = AMFolder<AMBoxStorage>(name, this);
    _folders[name] = folder;
    return folder;
  }

  AMFile<AMBoxStorage> file(String name) {
    if (_files[name] != null) return _files[name]!;
    var file = AMFile<AMBoxStorage>(name, this);
    // doc._initialize();
    _files[name] = file;
    return file;
  }

  Future<bool> reInitiate() async {
    return await parentApp.reInitiate();
  }
}
