import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  bool task1 = true;
  bool task2 = false;
  bool task3 = true;
  bool task4 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Management"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            taskCard("Follow up with technician", task1, (value) {
              setState(() {
                task1 = value!;
              });
            }),

            taskCard("Prepare monthly report", task2, (value) {
              setState(() {
                task2 = value!;
              });
            }),

            taskCard("Check rent collection", task3, (value) {
              setState(() {
                task3 = value!;
              });
            }),

            taskCard("Inspect common area", task4, (value) {
              setState(() {
                task4 = value!;
              });
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("New Task Added")),
                  );
                },

                icon: const Icon(Icons.add),

                label: const Text("Add Task"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget taskCard(String title, bool value, Function(bool?) onChanged) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: CheckboxListTile(
        value: value,

        onChanged: onChanged,

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
