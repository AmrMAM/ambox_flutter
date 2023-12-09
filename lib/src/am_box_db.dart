part of 'am_box.dart';

class AMBoxDB {
  // static final _dBs = <String, AMBoxDB>{};
  final _collections = <String, AMCollection<AMBoxDB>>{};
  final _documents = <String, AMDocument<AMBoxDB>>{};

  final AMApplication parentApp;
  // ignore: unused_element
  String get _id => parentApp._dbFolderID;

  AMBoxDB._init({
    required this.parentApp,
  });

  factory AMBoxDB(AMApplication parentApp) {
    return AMBoxDB._init(parentApp: parentApp);
  }

  AMCollection<AMBoxDB> collection(String name) {
    if (_collections[name] != null) return _collections[name]!;
    var col = AMCollection(collectionName: name, parent: this);
    _collections[name] = col;
    return col;
  }

  AMDocument<AMBoxDB> document(String name) {
    if (_documents[name] != null) return _documents[name]!;
    var doc = AMDocument<AMBoxDB>(this, name);
    // doc._initialize();
    _documents[name] = doc;
    return doc;
  }

  Future<bool> reInitiate() async {
    return await parentApp.reInitiate();
  }
}
