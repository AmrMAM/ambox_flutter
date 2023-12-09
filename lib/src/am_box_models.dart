part of './am_box.dart';

class AMResponse<T> {
  final T resposeContent;
  final int statusCode;
  final bool success;
  final String? errorMessage;

  AMResponse({
    required this.success,
    required this.resposeContent,
    required this.statusCode,
    this.errorMessage,
  });
}

/*
{
    "amBoxRootID": "1D7-g4SgRK6WwN3uhViTQKhy98fHZVou4",
    "amAppRootID": "1kOKMo0Hipk5gjhorGt6pcMAFW6cvsSc7",
    "amDBRootID": "1aPIdmWFX4jAHS2F9RBcGvfZiDG7QJiqE",
    "amStorageRootID": "1UCwTOqJpyPlg1zUf2wnfgPicVsRFg_Xd"
}
*/
class AppInitializeModel {
  final String amBoxRootID;
  final String amAppRootID;
  final String amDBRootID;
  final String amStorageRootID;

  AppInitializeModel({
    required this.amBoxRootID,
    required this.amAppRootID,
    required this.amDBRootID,
    required this.amStorageRootID,
  });

  Map<String, dynamic> toMap() {
    return {
      "amBoxRootID": amBoxRootID,
      "amAppRootID": amAppRootID,
      "amDBRootID": amDBRootID,
      "amStorageRootID": amStorageRootID,
    };
  }

  factory AppInitializeModel.fromMap(Map<String, dynamic> map) {
    return AppInitializeModel(
      amBoxRootID: map["amBoxRootID"],
      amAppRootID: map["amAppRootID"],
      amDBRootID: map["amDBRootID"],
      amStorageRootID: map["amStorageRootID"],
    );
  }
}

/*      File MetaData Model
  {
    "kind": "drive#file",
    "id": "1xT3206aUTcLpE8B-Hpddvup3OU31mEid",
    "name": "*col/Tasks",
    "mimeType": "application/vnd.google-apps.folder",
    "parents": ["1aPIdmWFX4jAHS2F9RBcGvfZiDG7QJiqE"]
  }
*/
class FileMetaDataModel {
  final String kind;
  final String id;
  final String name;
  final String mimeType;
  final List<String> parents;

  FileMetaDataModel({
    required this.kind,
    required this.id,
    required this.name,
    required this.mimeType,
    required this.parents,
  });

  Map<String, dynamic> toMap() {
    return {
      "kind": kind,
      "id": id,
      "name": name,
      "mimeType": mimeType,
      "parents": parents,
    };
  }

  factory FileMetaDataModel.fromMap(Map<String, dynamic> map) {
    return FileMetaDataModel(
      kind: map["kind"],
      id: map["id"],
      name: map["name"],
      mimeType: map["mimeType"],
      parents: (map["parents"] as List).map((e) => e as String).toList(),
    );
  }
}

/*
{
  "files": [
    {
      "kind": "drive#file",
      "mimeType": "application/json",
      "parents": [
        "1w0LgLMZynZsUHI7O9nZpYBCmkIjOwPQJ"
      ],
      "id": "1c2CF1od7r83ehVIik9j_1538Gin_SeOT",
      "name": "*doc/hellos.json"
    }
  ]
}
*/
class GetCollectionFolderResultModel {
  final List<FileMetaDataModel> files;

  GetCollectionFolderResultModel(this.files);

  Map<String, dynamic> toMap() {
    return {
      "files": files.map((e) => e.toMap()).toList(),
    };
  }

  factory GetCollectionFolderResultModel.fromMap(Map<String, dynamic> map) {
    return GetCollectionFolderResultModel((map["files"] as List)
        .map((e) => FileMetaDataModel.fromMap(e))
        .toList());
  }
}
