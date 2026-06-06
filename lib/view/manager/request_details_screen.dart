import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String docId;
  final String currentStatus;

  const RequestDetailsScreen({
    super.key,
    required this.docId,
    required this.currentStatus,
  });

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  late String currentStatus;

  @override
  void initState() {
    super.initState();

    switch (widget.currentStatus.toLowerCase()) {
      case "pending":
        currentStatus = "Pending";
        break;

      case "in progress":
        currentStatus = "In Progress";
        break;

      case "completed":
        currentStatus = "Completed";
        break;

      default:
        currentStatus = "Pending";
    }
  }

  final TextEditingController notesController = TextEditingController(
    text: "Technician is on the way.",
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Request Details"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            const Text(
              "Maintenance Request",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            const Text(
              "Current Status",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField<String>(
              value: currentStatus,

              items: const [
                DropdownMenuItem(value: "Pending", child: Text("Pending")),
                DropdownMenuItem(
                  value: "In Progress",
                  child: Text("In Progress"),
                ),
                DropdownMenuItem(value: "Completed", child: Text("Completed")),
              ],

              onChanged: (value) {
                setState(() {
                  currentStatus = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: notesController,
              maxLines: 4,

              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection("maintenance_requests")
                      .doc(widget.docId)
                      .update({"status": currentStatus.toLowerCase()});

                  if (!mounted) return;

                  Navigator.pop(context, currentStatus);

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Status updated successfully"),
                    ),
                  );
                },

                child: const Text("Update Status"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
