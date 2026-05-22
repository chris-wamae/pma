import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final TextEditingController taskController = TextEditingController();

  List<Map<String, dynamic>> tasks = [
    {"title": "Follow up with technician", "completed": true},
    {"title": "Prepare monthly report", "completed": false},
    {"title": "Check rent collection", "completed": true},
    {"title": "Inspect common area", "completed": false},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Management"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: taskController,

              decoration: InputDecoration(
                hintText: "Enter new task",
                prefixIcon: const Icon(Icons.task),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,

                itemBuilder: (context, index) {
                  return taskCard(
                    tasks[index]["title"],
                    tasks[index]["completed"],
                    (value) {
                      setState(() {
                        tasks[index]["completed"] = value;
                      });
                    },
                  );
                },
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),

                label: const Text("Add Task"),

                onPressed: () {
                  if (taskController.text.trim().isNotEmpty) {
                    setState(() {
                      tasks.add({
                        "title": taskController.text.trim(),
                        "completed": false,
                      });
                    });

                    taskController.clear();

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Task Added Successfully")),
                    );
                  }
                },
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

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,

            decoration: value
                ? TextDecoration.lineThrough
                : TextDecoration.none,
          ),
        ),
      ),
    );
  }
}
