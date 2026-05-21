import 'package:flutter/material.dart';

class ScheduleRepairScreen extends StatefulWidget {
  const ScheduleRepairScreen({super.key});

  @override
  State<ScheduleRepairScreen> createState() => _ScheduleRepairScreenState();
}

class _ScheduleRepairScreenState extends State<ScheduleRepairScreen> {
  String selectedRequest = "Leaking Pipe";
  String selectedWorker = "John Tan";

  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Schedule Repair")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: ListView(
          children: [
            const Text(
              "Select Request",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: selectedRequest,

              items: const [
                DropdownMenuItem(
                  value: "Leaking Pipe",
                  child: Text("Leaking Pipe"),
                ),
                DropdownMenuItem(
                  value: "Broken Aircond",
                  child: Text("Broken Aircond"),
                ),
                DropdownMenuItem(
                  value: "Light Not Working",
                  child: Text("Light Not Working"),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedRequest = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text(
              "Select Worker",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            DropdownButtonFormField(
              value: selectedWorker,

              items: const [
                DropdownMenuItem(value: "John Tan", child: Text("John Tan")),
                DropdownMenuItem(value: "Ahmed Ali", child: Text("Ahmed Ali")),
                DropdownMenuItem(value: "Mei Ling", child: Text("Mei Ling")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedWorker = value!;
                });
              },
            ),

            const SizedBox(height: 20),

            const Text("Notes", style: TextStyle(fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: notesController,
              maxLines: 4,

              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Enter repair notes...",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Repair Scheduled Successfully"),
                    ),
                  );
                },

                child: const Text("Schedule"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
