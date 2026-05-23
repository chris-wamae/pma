import 'package:flutter/material.dart';

class UploadFilesScreen extends StatefulWidget {
  const UploadFilesScreen({super.key});

  @override
  State<UploadFilesScreen> createState() => _UploadFilesScreenState();
}

class _UploadFilesScreenState extends State<UploadFilesScreen> {
  final TextEditingController descriptionController = TextEditingController();

  List<String> uploadHistory = [];

  String quotationFile = "quotation.pdf";

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

              children: [photoBox(), photoBox(), photoBox(), photoBox()],
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(const SnackBar(content: Text("Photo Added")));
              },

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
                  setState(() {
                    uploadHistory.insert(
                      0,
                      descriptionController.text.trim().isEmpty
                          ? "Repair Photo Set"
                          : descriptionController.text,
                    );
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
              (item) => Card(
                child: ListTile(
                  leading: const Icon(Icons.image),

                  title: Text(item),
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
