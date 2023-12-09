part of 'am_box.dart';

class AMDocument<ParentType> {
  /// Children Collections
  final _collections = <String, AMCollection<AMDocument<ParentType>>>{};

  final ParentType parent;
  String _id = "";
  bool _deleted = false;
  bool _initialized = false;

  String docName;
  Map<String, dynamic> _data = {};
  bool dataLoaded = false;

  AMDocument(this.parent, this.docName);

  Future<bool> saveData() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.saveDocument(
      accessToken: AMBox()._accessToken,
      docID: _id,
      docData: jsonEncode(_data.isEmpty ? {} : _data),
    );
    if (!res.success) return false;
    return true;
  }

  Map<String, dynamic> get data {
    if (dataLoaded) {
      return _data;
    } else {
      throw "Use 'await getData()' first before using 'data' field";
    }
  }

  /// to get data from the server or also you refresh the data you had;
  Future<bool> getData() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.getDocument(
      accessToken: AMBox()._accessToken,
      docID: _id,
    );
    if (!res.success) return false;
    dataLoaded = true;
    if ((res.resposeContent as String).isEmpty) {
      _data = {};
      return true;
    }
    _data = jsonDecode(res.resposeContent as String);
    return true;
  }

  /// app is deleted if returned true;
  Future<bool> delete() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.deleteFolderByID(_id, AMBox()._accessToken);
    if (!res) return false;
    (parent as dynamic)._documents.remove(docName);
    _deleted = true;
    return true;
  }

  AMCollection<AMDocument<ParentType>> collection(String name) {
    if (_collections[name] != null) return _collections[name]!;
    var col = AMCollection<AMDocument<ParentType>>(
        collectionName: name, parent: this);
    // col._initialize();
    _collections[name] = col;
    return col;
  }

  Future<bool> reInitiate() async {
    if (!_initialized || _deleted) {
      await _initialize();
      if (_initialized) {
        _deleted = false;
        return true;
      }
      return false;
    }
    return true;
  }

  Future _initialize() async {
    var con = await AMBox()._atReChecker();
    if (!con) {
      _initialized = false;
      return;
    }

    await (parent as dynamic).reInitiate();
    var res = await _AMBoxServices.document(
      accessToken: AMBox()._accessToken,
      colParentID: (parent as dynamic)._id,
      docName: docName,
    );
    if (!res.success) {
      _initialized = false;
      return;
    }
    var metaDataModel =
        FileMetaDataModel.fromMap(jsonDecode(res.resposeContent as String));
    _id = metaDataModel.id;
    _initialized = true;
    return;
  }

  Future<List<AMCollection<AMDocument<ParentType>>>> getCollections() async {
    await (parent as AMCollection)._getColDocs();
    return _collections.values.toList();
  }
}
