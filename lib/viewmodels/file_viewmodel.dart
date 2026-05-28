import 'package:flutter/foundation.dart';
import 'package:pma/models/file_model.dart';
import '../repositories/file_repository.dart';
 
class FileViewModel extends ChangeNotifier {
  final FileRepository _fileRepository;
 
  FileViewModel({required FileRepository fileRepository})
      : _fileRepository = fileRepository;
 
  bool _isLoading = false;
  String? _errorMessage;
  List<FileModel> _files = [];
 
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<FileModel> get files => _files;
 
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
 
  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }
 
Stream<List<FileModel>> fetchFilesForEntity(String entityId) {

  return _fileRepository.getFilesForEntity(entityId).map((fileList) {
    _files = fileList;
    return fileList;
  });
}
 
  Future<void> uploadFile({
    required Uint8List fileBytes,
    required String fileName,
    required String entityId,
    required String entityType,
    required String uploadedBy,
  }) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _fileRepository.uploadFile(
        fileBytes: fileBytes,
        fileName: fileName,
        entityId: entityId,
        entityType: entityType,
        uploadedBy: uploadedBy,
      );
    } catch (e) {
      _setErrorMessage('Failed to upload file: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
 
  Future<void> deleteFile(String fileId, String fileUrl) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _fileRepository.deleteFile(fileId, fileUrl);
    } catch (e) {
      _setErrorMessage('Failed to delete file: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }
 
  Future<String?> getDownloadUrl(String fileId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final String url = await _fileRepository.getDownloadUrl(fileId);
      return url;
    } catch (e) {
      _setErrorMessage('Failed to get download URL: ${e.toString()}');
      return null;
    } finally {
      _setLoading(false);
    }
  }
}
 