import 'package:flutter/material.dart';

class AssignWorkerScreen extends StatefulWidget {
  const AssignWorkerScreen({super.key});

  @override
  State<AssignWorkerScreen> createState() => _AssignWorkerScreenState();
}

class _AssignWorkerScreenState extends State<AssignWorkerScreen> {
  String selectedWorker = "John Tan";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Assign Worker")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: "Search worker...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 20),

            workerTile("John Tan", "Plumbing", "Available"),

            workerTile("Ahmed Ali", "Electrical", "Available"),

            workerTile("Mei Ling", "Maintenance", "Busy"),

            workerTile("Ravi Kumar", "General Repair", "Available"),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$selectedWorker assigned successfully"),
                    ),
                  );
                },

                child: Text("Assign to $selectedWorker"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget workerTile(String name, String skill, String status) {
    return RadioListTile<String>(
      value: name,
      groupValue: selectedWorker,

      onChanged: (value) {
        setState(() {
          selectedWorker = value!;
        });
      },

      title: Text(name),

      subtitle: Text("$skill • $status"),
    );
  }
}
