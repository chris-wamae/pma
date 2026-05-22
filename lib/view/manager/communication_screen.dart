import 'package:flutter/material.dart';

class CommunicationScreen extends StatefulWidget {
  const CommunicationScreen({super.key});

  @override
  State<CommunicationScreen> createState() => _CommunicationScreenState();
}

class _CommunicationScreenState extends State<CommunicationScreen> {
  String selectedTenant = "All Tenants";

  final TextEditingController messageController = TextEditingController(
    text:
        "Water supply will be interrupted tomorrow from 10:00 AM to 2:00 PM for maintenance works. Please plan ahead. Thank you.",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Announcement"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            const Text(
              "To",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedTenant,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),

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
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: messageController,
              maxLines: 8,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Attach File (Optional)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            Card(
              elevation: 3,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),

              child: const ListTile(
                leading: Icon(Icons.picture_as_pdf, color: Colors.red),

                title: Text("notice.pdf"),

                trailing: Icon(Icons.close),
              ),
            ),

            const SizedBox(height: 30),

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
