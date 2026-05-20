import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String pipeStatus = "Pending";
  String aircondStatus = "Urgent";
  String lightStatus = "In Progress";

  Color getStatusColor(String status) {
    if (status == "Pending") {
      return Colors.orange;
    } else if (status == "Urgent") {
      return Colors.red;
    } else if (status == "In Progress") {
      return Colors.blue;
    } else {
      return Colors.green;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Requests")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            // Leaking Pipe
            Card(
              child: ListTile(
                leading: const Icon(Icons.plumbing, color: Colors.blue),

                title: const Text("Leaking Pipe"),

                subtitle: const Text("Room A-12"),

                trailing: Text(
                  pipeStatus,

                  style: TextStyle(
                    color: getStatusColor(pipeStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (pipeStatus == "Pending") {
                    pipeStatus = "Completed";
                  } else {
                    pipeStatus = "Pending";
                  }
                });
              },

              child: const Text("Update Pipe Status"),
            ),

            const SizedBox(height: 25),

            // Broken Aircond
            Card(
              child: ListTile(
                leading: const Icon(Icons.ac_unit, color: Colors.cyan),

                title: const Text("Broken Aircond"),

                subtitle: const Text("Room B-03"),

                trailing: Text(
                  aircondStatus,

                  style: TextStyle(
                    color: getStatusColor(aircondStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (aircondStatus == "Urgent") {
                    aircondStatus = "Completed";
                  } else {
                    aircondStatus = "Urgent";
                  }
                });
              },

              child: const Text("Update Aircond Status"),
            ),

            const SizedBox(height: 25),

            // Light Issue
            Card(
              child: ListTile(
                leading: const Icon(Icons.lightbulb, color: Colors.amber),

                title: const Text("Light Not Working"),

                subtitle: const Text("Room C-07"),

                trailing: Text(
                  lightStatus,

                  style: TextStyle(
                    color: getStatusColor(lightStatus),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (lightStatus == "In Progress") {
                    lightStatus = "Completed";
                  } else {
                    lightStatus = "In Progress";
                  }
                });
              },

              child: const Text("Update Light Status"),
            ),
          ],
        ),
      ),
    );
  }
}
