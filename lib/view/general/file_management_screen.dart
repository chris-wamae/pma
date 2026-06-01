import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pma/models/file_model.dart';
import 'package:pma/viewmodels/file_viewmodel.dart';
import 'package:url_launcher/url_launcher.dart';

class FileManagementScreen extends StatefulWidget {
  final String entityId;
  final String entityType;
  final String uploadedBy;

  const FileManagementScreen({
    Key? key,
    required this.entityId,
    required this.entityType,
    required this.uploadedBy,
  }) : super(key: key);

  @override
  State<FileManagementScreen> createState() => _FileManagementScreenState();
}

class _FileManagementScreenState extends State<FileManagementScreen> {
  Future<void> _pickAndUploadFile() async {
    final fileViewModel = Provider.of<FileViewModel>(context, listen: false);

    FilePickerResult? result = await FilePicker.pickFiles(withData: true);

    if (result != null) {
      final pickedFile = result.files.single;
      final Uint8List? fileBytes = pickedFile.bytes;
      final String fileName = pickedFile.name;

      if (fileBytes == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not read file data. Please try again.'),
          ),
        );
        return;
      }

      await fileViewModel.uploadFile(
        fileBytes: fileBytes,
        fileName: fileName,
        entityId: widget.entityId,
        entityType: widget.entityType,
        uploadedBy: widget.uploadedBy,
      );

      if (!mounted) return;

      if (fileViewModel.errorMessage != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(fileViewModel.errorMessage!)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('File uploaded successfully!')),
        );
      }
    }
  }

  Future<void> _deleteFile(String fileId, String fileUrl) async {
    final fileViewModel = Provider.of<FileViewModel>(context, listen: false);
    await fileViewModel.deleteFile(fileId, fileUrl);

    if (!mounted) return;

    if (fileViewModel.errorMessage != null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(fileViewModel.errorMessage!)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('File deleted successfully!')),
      );
    }
  }

  Future<void> _downloadFile(String fileUrl) async {
    final url = Uri.parse(fileUrl);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not open file. Please check your device settings.',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Files for ${widget.entityType} - ${widget.entityId}'),
      ),
      body: Consumer<FileViewModel>(
        builder: (context, fileViewModel, child) {
          return StreamBuilder<List<FileModel>>(
            stream: fileViewModel.fetchFilesForEntity(widget.entityId),
            builder: (context, snapshot) {
              // ✅ Only use snapshot state, not fileViewModel.isLoading
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(child: Text('No files uploaded yet.'));
              }

              final files = snapshot.data!;
              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.insert_drive_file_outlined),
                      title: Text(file.name),
                      subtitle: Text(
                        'Uploaded by: ${file.uploadedBy}\n'
                        '${file.uploadedAt.toLocal().toString().split('.')[0]}',
                      ),
                      isThreeLine: true,
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.download_outlined),
                            tooltip: 'Download',
                            onPressed: () => _downloadFile(file.url),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            tooltip: 'Delete',
                            onPressed: () => _deleteFile(file.id, file.url),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadFile,
        tooltip: 'Upload file',
        child: const Icon(Icons.add),
      ),
    );
  }
}
