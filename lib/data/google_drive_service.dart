import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  final GoogleSignInAccount user;

  // The scope we need
  static const _scopes = [drive.DriveApi.driveAppdataScope];

  GoogleDriveService(this.user);

  /// Helper to get an authenticated client using the new authorizationClient
  Future<drive.DriveApi> _getDriveApi() async {
    // This follows the example you found: getting headers from authorizationClient
    final Map<String, String>? headers = await user.authorizationClient.authorizationHeaders(_scopes);

    if (headers == null) {
      throw Exception('Failed to get authorization headers. User may need to re-authorize.');
    }

    final client = GoogleAuthClient(headers);
    return drive.DriveApi(client);
  }

  /// Saves or Updates a note in the hidden appDataFolder
  Future<void> saveNoteToDrive(String fileName, Map<String, dynamic> noteData) async {
    final driveApi = await _getDriveApi();

    final content = utf8.encode(jsonEncode(noteData));
    final media = drive.Media(Stream.value(content), content.length);
    final fileMetadata = drive.File()
      ..name = fileName
      ..parents = ['appDataFolder'];

    // Check if file exists to determine if we 'create' or 'update'
    final list = await driveApi.files.list(
      q: "name = '$fileName' and 'appDataFolder' in parents",
      spaces: 'appDataFolder',
    );

    if (list.files != null && list.files!.isNotEmpty) {
      final fileId = list.files!.first.id!;
      await driveApi.files.update(fileMetadata, fileId, uploadMedia: media);
    } else {
      await driveApi.files.create(fileMetadata, uploadMedia: media);
    }
  }
}

/// Simple Authenticated HTTP Client
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}