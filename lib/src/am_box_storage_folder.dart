part of 'am_box.dart';

class AMFolder<ParentType> {
  /// Children Folders
  final _folders = <String, AMFolder<AMFolder<ParentType>>>{};

  /// Children Files
  final _files = <String, AMFile<AMFolder<ParentType>>>{};

  final ParentType parent;
  String _id = "";
  String folderName;

  bool _initialized = false;
  bool _deleted = false;

  AMFolder(this.folderName, this.parent);

  AMFolder<AMFolder<ParentType>> folder(String name) {
    if (_folders[name] != null) return _folders[name]!;
    var folder = AMFolder<AMFolder<ParentType>>(name, this);
    _folders[name] = folder;
    return folder;
  }

  AMFile<AMFolder<ParentType>> file(String name) {
    if (_files[name] != null) return _files[name]!;
    var file = AMFile<AMFolder<ParentType>>(name, this);
    // doc._initialize();
    _files[name] = file;
    return file;
  }

  Future _getFilesFolders() async {
    var con = await AMBox()._atReChecker();
    if (!con) throw "Cannot connect to the server";
    await reInitiate();
    var res =
        await _AMBoxServices.getAllInsideFolder(AMBox()._accessToken, _id);
    if (!res.success) throw "Errot happened while getting Folder data";
    var model =
        GetCollectionFolderResultModel.fromMap(jsonDecode(res.resposeContent));
    // print(model.toMap());
    for (var e in model.files) {
      // print(e.name);
      if (e.kind == "drive#file") {
        // var name = e.name.replaceAll('*doc/', "").replaceAll('.json', "");
        var file = AMFile<AMFolder<ParentType>>(e.name, this);
        _files[e.name] = _files[e.name] ?? file;
        file = _files[e.name]!;
        file._id = e.id;
        file._initialized = true;
      } else {
        var folder = AMFolder(e.name, this);
        _folders[e.name] = _folders[e.name] ?? folder;
        folder = _folders[e.name]!;
        folder._id = e.id;
        folder._initialized = true;
      }
    }
  }

  Future<List<AMFile<AMFolder<ParentType>>>> getFiles() async {
    await _getFilesFolders();
    return _files.values.toList();
  }

  Future<List<AMFolder<AMFolder<ParentType>>>> getFolders() async {
    await _getFilesFolders();
    return _folders.values.toList();
  }
  // Future<bool> rename(String newName) async {
  //   return true;
  // }

  /// app is deleted if returned true;
  Future<bool> deleteFolder() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.deleteFolderByID(_id, AMBox()._accessToken);
    if (!res) return false;
    (parent as dynamic)._folders.remove(folderName);
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

    var res = await _AMBoxServices.folder(
      accessToken: AMBox()._accessToken,
      folderName: folderName,
      parentID: (parent as dynamic)._id,
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
