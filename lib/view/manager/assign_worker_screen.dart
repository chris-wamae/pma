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
      appBar: AppBar(title: const Text("Assign Worker"), centerTitle: true),

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

            Expanded(
              child: ListView(
                children: [
                  workerCard("John Tan", "Plumbing", "4.8", "Available"),

                  workerCard("Ahmed Ali", "Electrical", "4.6", "Available"),

                  workerCard("Mei Ling", "Maintenance", "4.5", "Busy"),

                  workerCard(
                    "Ravi Kumar",
                    "General Repair",
                    "4.7",
                    "Available",
                  ),
                ],
              ),
            ),

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

  Widget workerCard(String name, String skill, String rating, String status) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: RadioListTile<String>(
        value: name,
        groupValue: selectedWorker,

        onChanged: (value) {
          setState(() {
            selectedWorker = value!;
          });
        },

        secondary: const CircleAvatar(child: Icon(Icons.person)),

        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text("$skill • $rating ★"),

            Text(
              status,
              style: TextStyle(
                color: status == "Available" ? Colors.green : Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
