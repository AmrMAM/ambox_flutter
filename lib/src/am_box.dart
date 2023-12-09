// ignore_for_file: unused_field, prefer_final_fields

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

part './am_box_services.dart';
part './am_box_info.dart';
part 'am_box_models.dart';
part 'am_box_app.dart';
part 'am_box_db.dart';
part 'am_box_db_collection.dart';
part 'am_box_db_doc.dart';
part 'am_box_storage.dart';
part 'am_box_storage_folder.dart';
part 'am_box_storage_file.dart';

class AMBox {
  static final _inst = AMBox._init();
  AMBox._init();
  factory AMBox() => _inst;
  factory AMBox.instance() => _inst;
  //--------------------------------------------------------------//
  String _loginToken = "", _accessToken = "";
  DateTime _accessTokenStartedAt = DateTime(1980);
  //--------------------------------------------------------------//

  /// if returned true that means successfully initialized;
  Future<void> initialize(String loginToken) async {
    AMBox()._loginToken = loginToken;
    // return await _atReChecker();
  }

  Future<bool> _refreshAccesstoken() async {
    var res = await _AMBoxServices.getAccessToken(_loginToken);
    if (res.success) {
      _accessToken = res.resposeContent as String;
      _accessTokenStartedAt = DateTime.now();
      return true;
    } else {
      return false;
    }
  }

  bool _isAccessTokenReadyToUse() {
    if (_accessToken.isEmpty) return false;
    if (_accessTokenStartedAt
        .add(const Duration(minutes: 45))
        .isAfter(DateTime.now())) {
      return true;
    }
    return false;
  }

  Future<bool> _atReChecker() async {
    if (_isAccessTokenReadyToUse()) return true;
    var res = await _refreshAccesstoken();
    return res;
  }

  AMApplication application(String appName) {
    return AMApplication(appName);
  }
}
