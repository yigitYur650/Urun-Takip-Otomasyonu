import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;
import '../config/env.dart';
import '../error/exceptions.dart';

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request..headers.addAll(_headers));
  }
}

class GoogleDriveService {
  GoogleSignInAccount? _currentUser;
  drive.DriveApi? _driveApi;
  bool _isInitialized = false;

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      await GoogleSignIn.instance.initialize(
        serverClientId: Env.googleServerClientId,
      );
      _isInitialized = true;
    }
  }

  Future<void> signIn() async {
    await _ensureInitialized();
    try {
      _currentUser = await GoogleSignIn.instance.attemptLightweightAuthentication();
      if (_currentUser == null) {
         _currentUser = await GoogleSignIn.instance.authenticate(
           scopeHint: [drive.DriveApi.driveAppdataScope],
         );
      }

      final authHeaders = await _currentUser!.authorizationClient.authorizationHeaders(
        [drive.DriveApi.driveAppdataScope],
        promptIfNecessary: true,
      );

      if (authHeaders == null) {
        throw const ServerException('Failed to get authorization headers');
      }

      final authenticateClient = GoogleAuthClient(authHeaders);
      _driveApi = drive.DriveApi(authenticateClient);
    } catch (e) {
      throw ServerException('Failed to sign in: $e');
    }
  }

  Future<void> signOut() async {
    await _ensureInitialized();
    await GoogleSignIn.instance.signOut();
    _currentUser = null;
    _driveApi = null;
  }

  Future<bool> get isSignedIn async {
    await _ensureInitialized();
    if (_currentUser != null) return true;
    try {
      _currentUser = await GoogleSignIn.instance.attemptLightweightAuthentication();
      return _currentUser != null;
    } catch (_) {
      return false;
    }
  }

  Future<void> backupDatabase(File dbFile) async {
    if (_driveApi == null) {
      throw const ServerException('Drive API not initialized. Call signIn() first.');
    }

    try {
      final fileName = dbFile.path.split(Platform.pathSeparator).last;
      
      final fileList = await _driveApi!.files.list(
        spaces: 'appDataFolder',
        q: "name = '$fileName'",
      );

      final media = drive.Media(dbFile.openRead(), dbFile.lengthSync());
      final driveFile = drive.File()
        ..name = fileName
        ..parents = ['appDataFolder'];

      if (fileList.files != null && fileList.files!.isNotEmpty) {
        final existingFileId = fileList.files!.first.id!;
        await _driveApi!.files.update(
          driveFile,
          existingFileId,
          uploadMedia: media,
        );
      } else {
        await _driveApi!.files.create(
          driveFile,
          uploadMedia: media,
        );
      }
    } catch (e) {
      throw ServerException('Backup failed: $e');
    }
  }

  Future<void> restoreDatabase(File targetFile) async {
    if (_driveApi == null) {
      throw const ServerException('Drive API not initialized. Call signIn() first.');
    }

    try {
      final fileName = targetFile.path.split(Platform.pathSeparator).last;
      
      final fileList = await _driveApi!.files.list(
        spaces: 'appDataFolder',
        q: "name = '$fileName'",
      );

      if (fileList.files == null || fileList.files!.isEmpty) {
        throw const ServerException('No backup found to restore');
      }

      final fileId = fileList.files!.first.id!;
      
      final drive.Media media = await _driveApi!.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final bytes = <int>[];
      await for (final chunk in media.stream) {
        bytes.addAll(chunk);
      }

      await targetFile.writeAsBytes(bytes, flush: true);
    } catch (e) {
      throw ServerException('Restore failed: $e');
    }
  }
}
