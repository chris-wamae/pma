import 'package:flutter/material.dart';
import 'package:pma/view/manager/maintenance_screen.dart';
import 'package:pma/view/manager/task_management_screen.dart';
import 'package:pma/view/manager/communication_screen.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Maintenance Dashboard")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            Row(
              children: [
                Expanded(child: dashboardBox("24", "Total Requests")),

                const SizedBox(width: 10),

                Expanded(child: dashboardBox("10", "In Progress")),
              ],
            ),

            const SizedBox(height: 10),

            Row(
              children: [
                Expanded(child: dashboardBox("12", "Completed")),

                const SizedBox(width: 10),

                Expanded(child: dashboardBox("5", "Urgent")),
              ],
            ),

            const SizedBox(height: 25),

            const Text(
              "Recent Requests",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            requestCard("Leaking Pipe", "Room A-12", "Urgent", Colors.red),

            requestCard(
              "Broken Aircond",
              "Room B-03",
              "In Progress",
              Colors.orange,
            ),

            requestCard(
              "Light Not Working",
              "Room C-07",
              "Completed",
              Colors.green,
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintenanceScreen(),
                    ),
                  );
                },

                child: const Text("Issues & Maintenance"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TaskManagementScreen(),
                    ),
                  );
                },

                child: const Text("Task Management"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CommunicationScreen(),
                    ),
                  );
                },

                child: const Text("Communication"),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {},

                child: const Text("Service Coordination"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardBox(String number, String title) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),

        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        children: [
          Text(
            number,

            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 5),

          Text(title),
        ],
      ),
    );
  }

  Widget requestCard(
    String title,
    String room,
    String status,
    Color statusColor,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        title: Text(title),

        subtitle: Text(room),

        trailing: Text(
          status,

          style: TextStyle(color: statusColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
