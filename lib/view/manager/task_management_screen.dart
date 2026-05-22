import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  final TextEditingController taskController = TextEditingController();

  String selectedWorker = "John Tan";
  String selectedPriority = "Medium";

  List<Map<String, dynamic>> tasks = [
    {
      "title": "Follow up with technician",
      "worker": "John Tan",
      "priority": "High",
      "completed": true,
    },
    {
      "title": "Prepare monthly report",
      "worker": "Manager",
      "priority": "Medium",
      "completed": false,
    },
    {
      "title": "Check rent collection",
      "worker": "Admin",
      "priority": "Low",
      "completed": true,
    },
    {
      "title": "Inspect common area",
      "worker": "Ahmed Ali",
      "priority": "Medium",
      "completed": false,
    },
  ];

  Color getPriorityColor(String priority) {
    switch (priority) {
      case "High":
        return Colors.red;

      case "Medium":
        return Colors.orange;

      case "Low":
        return Colors.green;

      default:
        return Colors.grey;
    }
  }

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

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedWorker,

              decoration: const InputDecoration(
                labelText: "Assign Worker",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "John Tan", child: Text("John Tan")),
                DropdownMenuItem(value: "Ahmed Ali", child: Text("Ahmed Ali")),
                DropdownMenuItem(value: "Mei Ling", child: Text("Mei Ling")),
                DropdownMenuItem(
                  value: "Ravi Kumar",
                  child: Text("Ravi Kumar"),
                ),
              ],

              onChanged: (value) {
                setState(() {
                  selectedWorker = value!;
                });
              },
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              value: selectedPriority,

              decoration: const InputDecoration(
                labelText: "Priority",
                border: OutlineInputBorder(),
              ),

              items: const [
                DropdownMenuItem(value: "High", child: Text("High")),
                DropdownMenuItem(value: "Medium", child: Text("Medium")),
                DropdownMenuItem(value: "Low", child: Text("Low")),
              ],

              onChanged: (value) {
                setState(() {
                  selectedPriority = value!;
                });
              },
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: tasks.length,

                itemBuilder: (context, index) {
                  return taskCard(
                    tasks[index]["title"],
                    tasks[index]["worker"],
                    tasks[index]["priority"],
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
                        "worker": selectedWorker,
                        "priority": selectedPriority,
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

  Widget taskCard(
    String title,
    String worker,
    String priority,
    bool value,
    Function(bool?) onChanged,
  ) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: CheckboxListTile(
        value: value,

        onChanged: onChanged,

        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,

                decoration: value
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),

            const SizedBox(height: 4),

            Text("Assigned: $worker", style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 2),

            Text(
              "Priority: $priority",
              style: TextStyle(
                color: getPriorityColor(priority),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
