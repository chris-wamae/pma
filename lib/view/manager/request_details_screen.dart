import 'package:flutter/material.dart';

class RequestDetailsScreen extends StatefulWidget {
  const RequestDetailsScreen({super.key});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  String currentStatus = "In Progress";

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
              "Leaking Pipe in Kitchen",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text("Unit A-3-1"),

            const SizedBox(height: 20),

            const Text(
              "Description",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            const Text(
              "There is a leakage under the kitchen sink. "
              "Water is dripping continuously.",
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
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Status Updated Successfully"),
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
