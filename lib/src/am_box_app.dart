part of './am_box.dart';

class AMApplication {
  static final _apps = <String, AMApplication>{};

  late final AMBoxDB amBoxDB;
  late final AMBoxStorage amBoxStorage;

  String _dbFolderID = "",
      _storageFolderID = "",
      _appFolderID = "",
      // ignore: unused_field
      _boxRootID = "";
  bool _initialized = false;

  final String appName;
  bool _deleted = false;

  factory AMApplication(String appName) {
    if (_apps[appName] != null) return _apps[appName]!;
    var app = AMApplication._create(appName);
    // SynchronousFuture(app._initialize()).;
    _apps[appName] = app;
    return app;
  }

  Future _initialize() async {
    var con = await AMBox()._atReChecker();
    if (!con) {
      _initialized = false;
      return;
    }

    var res =
        await _AMBoxServices.initializeAppBox(appName, AMBox()._accessToken);
    if (!res.success) {
      _initialized = false;
      return;
    }
    var appModel =
        AppInitializeModel.fromMap(jsonDecode(res.resposeContent as String));
    _appFolderID = appModel.amAppRootID;
    _boxRootID = appModel.amBoxRootID;
    _dbFolderID = appModel.amDBRootID;
    _storageFolderID = appModel.amStorageRootID;
    _initialized = true;
    return;
  }

  AMApplication._create(this.appName) {
    amBoxDB = AMBoxDB(this);
    amBoxStorage = AMBoxStorage(this);
  }

  // AMBoxDB get amBoxDB => AMBoxDB(_dbFolderID, this);
  // AMBoxStorage get amBoxStorage => AMBoxStorage(_storageFolderID);

  /// app is deleted if returned true;
  Future<bool> deleteApp() async {
    var con = await AMBox()._atReChecker();
    if (!con) return false;
    var res = await _AMBoxServices.deleteFolderByID(
        _appFolderID, AMBox()._accessToken);
    if (!res) return false;
    _apps.remove(_appFolderID);
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
}
