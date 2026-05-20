import 'package:flutter/material.dart';

class TaskManagementScreen extends StatefulWidget {
  const TaskManagementScreen({super.key});

  @override
  State<TaskManagementScreen> createState() => _TaskManagementScreenState();
}

class _TaskManagementScreenState extends State<TaskManagementScreen> {
  String elevatorStatus = "Pending";
  String technicianStatus = "Completed";
  String inspectionStatus = "In Progress";

  Color getStatusColor(String status) {
    if (status == "Pending") {
      return Colors.orange;
    } else if (status == "Completed") {
      return Colors.green;
    } else {
      return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Task Management")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Elevator Task
            Card(
              child: ListTile(
                leading: const Icon(Icons.elevator, color: Colors.grey),

                title: const Text("Repair Elevator"),

                subtitle: const Text("Technician: John"),

                trailing: Text(
                  elevatorStatus,

                  style: TextStyle(
                    color: getStatusColor(elevatorStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (elevatorStatus == "Pending") {
                    elevatorStatus = "Completed";
                  } else {
                    elevatorStatus = "Pending";
                  }
                });
              },

              child: const Text("Update Elevator Task"),
            ),

            const SizedBox(height: 25),

            // Technician Task
            Card(
              child: ListTile(
                leading: const Icon(Icons.person, color: Colors.purple),

                title: const Text("Contact Technician"),

                subtitle: const Text("Technician: Alex"),

                trailing: Text(
                  technicianStatus,

                  style: TextStyle(
                    color: getStatusColor(technicianStatus),

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (technicianStatus == "Completed") {
                    technicianStatus = "Pending";
                  } else {
                    technicianStatus = "Completed";
                  }
                });
              },

              child: const Text("Update Technician Task"),
            ),

            const SizedBox(height: 25),

            // Inspection Task
            Card(
              child: ListTile(
                leading: const Icon(Icons.search, color: Colors.teal),

                title: const Text("Inspect Water Leak"),

                subtitle: const Text("Technician: Kevin"),

                trailing: Text(
                  inspectionStatus,

                  style: TextStyle(
                    color: getStatusColor(inspectionStatus),

                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (inspectionStatus == "In Progress") {
                    inspectionStatus = "Completed";
                  } else {
                    inspectionStatus = "In Progress";
                  }
                });
              },

              child: const Text("Update Inspection Task"),
            ),
          ],
        ),
      ),
    );
  }
}
