part of 'am_box.dart';

class AMFile<ParentType> {
  final ParentType parent;

  /// not used field at all;
  String _id = "";
  bool _deleted = false;
  bool _initialized = false;

  String fileName;
  String _data = "";
  bool dataLoaded = false;

  AMFile(this.fileName, this.parent);

  Future<bool> uploadFileContent(String fileContent) async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.updateFile(
      accessToken: AMBox()._accessToken,
      fileName: fileName,
      parentID: (parent as dynamic)._id,
      fileContent: fileContent,
    );
    if (!res.success) return false;
    _data = fileContent;
    dataLoaded = true;
    return true;
  }

  String get data {
    if (dataLoaded || _deleted) {
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
    var res = await _AMBoxServices.downloadFile(
      accessToken: AMBox()._accessToken,
      fileName: fileName,
      parentID: (parent as dynamic)._id,
    );
    if (!res.success) return false;
    dataLoaded = true;
    _data = res.resposeContent as String;
    return true;
  }

  /// app is deleted if returned true;
  Future<bool> delete() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    await reInitiate();
    var res = await _AMBoxServices.deleteFile(
      accessToken: AMBox()._accessToken,
      fileName: fileName,
      parentID: (parent as dynamic)._id,
    );
    if (!res.success) return false;
    (parent as dynamic)._files.remove(fileName);
    _deleted = true;
    _data = "";
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
    _initialized = true;
    return;
  }

  Uint8List get fileDataUint8List => Uint8List.fromList(data.codeUnits);
  String get fileDataString => data;
}
