// ignore_for_file: unused_element

part of './am_box.dart';

abstract class _AMBoxServices {
  static Future<AMResponse> initializeAppBox(
      String appName, String accessToken) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/initializeAmBox?appName=$appName'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> getAccessToken(String loginToken) async {
    var headers = {'amData': loginToken};
    var request = http.Request(
      'GET',
      Uri.parse('${_AMBoxInfo.hostUrl}/AMUser/getAccessToken'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<bool> deleteFolderByID(
      String folderID, String accessToken) async {
    var headers = {'amToken': accessToken};

    var request = http.Request(
      'DELETE',
      Uri.parse(
          '${_AMBoxInfo.hostUrl}/amBox/amStorageBox/deleteFolderByID?folderID=$folderID'),
    );

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  static Future<AMResponse> collection({
    required String accessToken,
    required String collectionName,
    required String colParentID,
    String parentDocName = "",
  }) async {
    var headers = {
      'amToken': accessToken,
    };
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/collection?collectionName=$collectionName&colParentID=$colParentID&parentDocName=$parentDocName'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> document({
    required String accessToken,
    required String docName,
    required String colParentID,
  }) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/document?docName=$docName&colParentID=$colParentID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> getDocument(
      {required String accessToken, required String docID}) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/getDocument?docID=$docID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> saveDocument({
    required String accessToken,
    required String docID,
    required String docData,
  }) async {
    var headers = {'amToken': accessToken, 'Content-Type': 'text/plain'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/saveDocument?docID=$docID'));
    request.body = docData;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> getCollection(
      String accessToken, String colID) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/getCollection?collectionID=$colID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> getAllInsideFolder(
      String accessToken, String folderID) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amDBBox/getAllColsDocsInCollection?collectionID=$folderID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> folder({
    required String accessToken,
    required String folderName,
    required String parentID,
  }) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amStorageBox/folder?folderName=$folderName&folderParentID=$parentID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> updateFile({
    required String accessToken,
    required String fileName,
    required String parentID,
    required String fileContent,
  }) async {
    var headers = {'amToken': accessToken, 'Content-Type': 'text/plain'};
    var request = http.Request(
        'POST',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amStorageBox/updateFile?fileName=$fileName&folderParentID=$parentID'));
    request.body = fileContent;
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> downloadFile({
    required String accessToken,
    required String fileName,
    required String parentID,
  }) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'GET',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amStorageBox/downloadFile?fileName=$fileName&folderParentID=$parentID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }

  static Future<AMResponse> deleteFile({
    required String accessToken,
    required String fileName,
    required String parentID,
  }) async {
    var headers = {'amToken': accessToken};
    var request = http.Request(
        'DELETE',
        Uri.parse(
            '${_AMBoxInfo.hostUrl}/amBox/amStorageBox/deleteFile?fileName=$fileName&folderParentID=$parentID'));

    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return AMResponse(
        success: true,
        resposeContent: await response.stream.bytesToString(),
        statusCode: 200,
      );
    } else {
      return AMResponse(
        success: false,
        resposeContent: await response.stream.bytesToString(),
        statusCode: response.statusCode,
        errorMessage: response.reasonPhrase,
      );
    }
  }
}
