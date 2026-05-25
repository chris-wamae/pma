import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UploadRecord {
  final String title;
  final List<File> photos;

  UploadRecord({required this.title, required this.photos});
}

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  final TextEditingController descriptionController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  List<File> photos = [];

  List<UploadRecord> uploadHistory = [];

  String quotationFile = "quotation.pdf";

  Future<void> pickImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        photos.add(File(image.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Files"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            const Text(
              "Photos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 15),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,

              children: [
                ...photos.map(
                  (photo) => Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),

                        child: Image.file(
                          photo,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),

                      Positioned(
                        top: 5,
                        right: 5,

                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              photos.remove(photo);
                            });
                          },

                          child: const CircleAvatar(
                            radius: 12,
                            backgroundColor: Colors.red,

                            child: Icon(
                              Icons.close,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                GestureDetector(onTap: pickImage, child: photoBox()),
              ],
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.add),
              label: const Text("Add More"),
            ),

            const SizedBox(height: 25),

            const Text(
              "Quotation",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Card(
              child: ListTile(
                leading: const Icon(Icons.picture_as_pdf, color: Colors.red),

                title: Text(quotationFile),

                trailing: const Icon(Icons.upload_file),
              ),
            ),

            const SizedBox(height: 25),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: descriptionController,
              maxLines: 4,

              decoration: InputDecoration(
                hintText: "Uploaded photos of repair work...",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  if (photos.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select at least one photo"),
                      ),
                    );
                    return;
                  }

                  setState(() {
                    uploadHistory.insert(
                      0,
                      UploadRecord(
                        title: descriptionController.text.trim().isEmpty
                            ? "Repair Photo Set"
                            : descriptionController.text,

                        photos: List<File>.from(photos),
                      ),
                    );

                    photos.clear();
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Files Uploaded Successfully"),
                    ),
                  );

                  descriptionController.clear();
                },

                child: const Text("Upload"),
              ),
            ),

            const SizedBox(height: 25),

            if (uploadHistory.isNotEmpty)
              const Text(
                "Recent Uploads",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            const SizedBox(height: 10),

            ...uploadHistory.map(
              (record) => Card(
                child: ListTile(
                  leading: const Icon(Icons.image),

                  title: Text(record.title),

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [
                      IconButton(
                        icon: const Icon(Icons.visibility),

                        onPressed: () {
                          showDialog(
                            context: context,

                            builder: (_) => AlertDialog(
                              title: Text(record.title),

                              content: SizedBox(
                                width: double.maxFinite,

                                child: GridView.builder(
                                  shrinkWrap: true,

                                  itemCount: record.photos.length,

                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                      ),

                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.all(4),

                                      child: Image.file(
                                        record.photos[index],
                                        fit: BoxFit.cover,
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          setState(() {
                            uploadHistory.remove(record);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Upload deleted")),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget photoBox() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),

      child: const Center(child: Icon(Icons.camera_alt, size: 40)),
    );
  }
}
