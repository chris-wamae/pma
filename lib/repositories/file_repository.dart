import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pma/models/file_model.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert'; // ← add this
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pma/models/file_model.dart';
import 'package:mime/mime.dart';
import 'package:uuid/uuid.dart';

class FileRepository {
  final String _collectionName = 'files';
  final _uuid = const Uuid();

  Future<Directory> get _storageDir async {
    final appDir = await getApplicationDocumentsDirectory();
    final filesDir = Directory('${appDir.path}/$_collectionName');
    if (!await filesDir.exists()) {
      await filesDir.create(recursive: true);
    }
    return filesDir;
  }

  Future<File> get _metadataFile async {
    final appDir = await getApplicationDocumentsDirectory();
    return File('${appDir.path}/files_metadata.json');
  }

  Future<List<Map<String, dynamic>>> _readMetadata() async {
    try {
      final file = await _metadataFile;
      if (!await file.exists()) return [];
      final content = await file.readAsString();
      if (content.isEmpty) return [];
      final decoded = jsonDecode(content) as List<dynamic>;
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<void> _writeMetadata(List<Map<String, dynamic>> metadata) async {
    final file = await _metadataFile;
    await file.writeAsString(jsonEncode(metadata));
  }

  Future<FileModel> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String entityId,
    required String entityType,
    required String uploadedBy,
  }) async {
    try {
      final dir = await _storageDir;
      final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_$fileName';
      final File localFile = File('${dir.path}/$uniqueFileName');
      await localFile.writeAsBytes(fileBytes);

      final FileModel fileModel = FileModel(
        id: _uuid.v4(),
        name: uniqueFileName,
        url: localFile.path, // local path used as "url"
        uploadedBy: uploadedBy,
        uploadedAt: DateTime.now(),
        associatedEntityId: entityId,
        associatedEntityType: entityType,
      );

      final metadata = await _readMetadata();
      metadata.add(fileModel.toJson());
      await _writeMetadata(metadata);

      return fileModel;
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  Stream<List<FileModel>> getFilesForEntity(String entityId) async* {
    try {
      final metadata = await _readMetadata();
      final files = metadata
          .map((json) => FileModel.fromJson(json))
          .where((f) => f.associatedEntityId == entityId)
          .toList();
      yield files;
    } catch (e) {
      throw Exception('Failed to fetch files: $e');
    }
  }

  Future<void> deleteFile(String fileId, String fileUrl) async {
    try {
      // Delete the actual file
      final file = File(fileUrl);
      if (await file.exists()) {
        await file.delete();
      }

      // Remove from metadata
      final metadata = await _readMetadata();
      metadata.removeWhere((json) => json['id'] == fileId);
      await _writeMetadata(metadata);
    } catch (e) {
      throw Exception('Failed to delete file: $e');
    }
  }

  Future<String> getDownloadUrl(String fileId) async {
    try {
      final metadata = await _readMetadata();
      final entry = metadata.firstWhere(
        (json) => json['id'] == fileId,
        orElse: () => throw Exception('File not found'),
      );
      return FileModel.fromJson(entry).url;
    } catch (e) {
      throw Exception('Failed to get file path: $e');
    }
  }
}