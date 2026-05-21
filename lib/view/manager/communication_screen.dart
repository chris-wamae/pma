import 'package:flutter/material.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  String selectedTenant = "All Tenants";

  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Announcement")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text("To", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: selectedTenant,

              items: const [
                DropdownMenuItem(
                  value: "All Tenants",
                  child: Text("All Tenants"),
                ),

                DropdownMenuItem(value: "Block A", child: Text("Block A")),

                DropdownMenuItem(value: "Block B", child: Text("Block B")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedTenant = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Message",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            TextField(
              controller: messageController,
              maxLines: 6,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Type announcement here...",
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Attachment",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(15),

              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: const Row(
                children: [
                  Icon(Icons.picture_as_pdf),

                  SizedBox(width: 10),

                  Text("notice.pdf"),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Announcement Sent Successfully"),
                    ),
                  );
                },

                child: const Text("Send Announcement"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
