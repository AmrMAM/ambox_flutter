part of 'am_box.dart';

class AMCollection<ParentType> {
  /// Children Collections
  final _collections = <String, AMCollection<AMCollection<ParentType>>>{};

  /// Children Documents
  final _documents = <String, AMDocument<AMCollection<ParentType>>>{};

  final ParentType parent;
  String _id = "";
  String collectionName;

  bool _initialized = false;
  bool _deleted = false;

  AMCollection({required this.collectionName, required this.parent});

  AMCollection<AMCollection<ParentType>> collection(String name) {
    if (_collections[name] != null) return _collections[name]!;
    var col = AMCollection<AMCollection<ParentType>>(
        collectionName: name, parent: this);
    // col._initialize();
    _collections[name] = col;
    return col;
  }

  AMDocument<AMCollection<ParentType>> document(String name) {
    if (_documents[name] != null) return _documents[name]!;
    var doc = AMDocument<AMCollection<ParentType>>(this, name);
    // doc._initialize();
    _documents[name] = doc;
    return doc;
  }

  Future _getColDocs() async {
    var con = await AMBox()._atReChecker();
    if (!con) throw "Cannot connect to the server";
    await reInitiate();
    var res =
        await _AMBoxServices.getAllInsideFolder(AMBox()._accessToken, _id);
    if (!res.success) {
      throw "Errot happened while getting collection data \r\n ${res.errorMessage}";
    }
    var model =
        GetCollectionFolderResultModel.fromMap(jsonDecode(res.resposeContent));
    // print(model.toMap());
    for (var e in model.files) {
      // print(e.name);
      if (e.name.contains("*doc/")) {
        var name = e.name.replaceAll('*doc/', "").replaceAll('.json', "");
        var doc = AMDocument<AMCollection<ParentType>>(this, name);
        _documents[name] = _documents[name] ?? doc;
        doc = _documents[name]!;
        doc._id = e.id;
        doc._initialized = true;
      } else {
        var t = e.name.split('/');
        var name = t.last;
        if (t.length == 3) {
          var docParent = this.document(t[1]);
          var col = AMCollection(collectionName: name, parent: docParent);
          docParent._collections[name] = docParent._collections[name] ?? col;
          col = docParent._collections[name]!;
          col._id = e.id;
          col._initialized = true;
        } else {
          var col = AMCollection(collectionName: name, parent: this);
          _collections[name] = _collections[name] ?? col;
          col = _collections[name]!;
          col._id = e.id;
          col._initialized = true;
        }
      }
    }
  }

  Future<List<AMDocument<AMCollection<ParentType>>>> getCollectionDocs() async {
    await _getColDocs();
    return _documents.values.toList();
  }

  Future<List<AMCollection<AMCollection<ParentType>>>>
      getCollectionCols() async {
    await _getColDocs();
    return _collections.values.toList();
  }
  // Future<bool> rename(String newName) async {
  //   return true;
  // }

  /// app is deleted if returned true;
  Future<bool> deleteCollection() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.deleteFolderByID(_id, AMBox()._accessToken);
    if (!res) return false;
    (parent as dynamic)._collections.remove(collectionName);
    _deleted = true;
    return true;
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
    bool docParent = parent is AMDocument<dynamic>;
    var parentDocName = docParent ? (parent as AMDocument).docName : "";

    var res = await _AMBoxServices.collection(
      accessToken: AMBox()._accessToken,
      colParentID:
          docParent ? (parent as dynamic).parent._id : (parent as dynamic)._id,
      collectionName: collectionName,
      parentDocName: parentDocName,
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
}
