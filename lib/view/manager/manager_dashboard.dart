import 'package:flutter/material.dart';
import 'package:pma/view/manager/maintenance_screen.dart';
import 'package:pma/view/manager/task_management_screen.dart';
import 'package:pma/view/manager/communication_screen.dart';
import 'package:pma/view/manager/worker_performance_screen.dart';
import 'package:pma/view/manager/schedule_repair_screen.dart';

class ManagerDashboard extends StatelessWidget {
  const ManagerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance Dashboard"),
        centerTitle: false,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            // Statistics
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

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Requests",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                TextButton(onPressed: () {}, child: const Text("View All")),
              ],
            ),

            const SizedBox(height: 8),

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

            const SizedBox(height: 25),

            const Text(
              "Manager Functions",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            functionCard(
              context,
              "Issues & Maintenance",
              Icons.build,
              const MaintenanceScreen(),
            ),

            functionCard(
              context,
              "Task Management",
              Icons.assignment,
              const TaskManagementScreen(),
            ),

            functionCard(
              context,
              "Communication",
              Icons.campaign,
              const CommunicationScreen(),
            ),

            functionCard(
              context,
              "Worker Performance",
              Icons.people,
              const WorkerPerformanceScreen(),
            ),

            functionCard(
              context,
              "Schedule Repair",
              Icons.calendar_month,
              const ScheduleRepairScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardBox(String number, String title) {
    return Container(
      height: 120,

      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Text(
            number,
            style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget requestCard(String title, String room, String status, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(room),

        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget functionCard(
    BuildContext context,
    String title,
    IconData icon,
    Widget? screen,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        trailing: const Icon(Icons.arrow_forward_ios),

        onTap: () {
          if (screen != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => screen),
            );
          }
        },
      ),
    );
  }
}
