import 'package:flutter/material.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String pipeStatus = "In Progress";
  String aircondStatus = "In Progress";
  String doorStatus = "Completed";
  String heaterStatus = "Completed";

  String selectedFilter = "All";

  final TextEditingController searchController = TextEditingController();

  Color getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;

      case "In Progress":
        return Colors.blue;

      case "Completed":
        return Colors.green;

      case "Urgent":
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Work Progress"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: "Search request...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  filterButton("All"),

                  filterButton("Pending"),

                  filterButton("In Progress"),

                  filterButton("Completed"),

                  filterButton("Urgent"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView(
                children: [
                  buildRequestCard(
                    title: "Leaking Pipe in Kitchen",
                    unit: "Unit A-3-1",
                    worker: "John Tan",
                    status: pipeStatus,
                  ),

                  buildRequestCard(
                    title: "Aircon Not Working",
                    unit: "Unit B-2-4",
                    worker: "Ahmed Ali",
                    status: aircondStatus,
                  ),

                  buildRequestCard(
                    title: "Door Lock Broken",
                    unit: "Unit C-1-2",
                    worker: "Mei Ling",
                    status: doorStatus,
                  ),

                  buildRequestCard(
                    title: "Water Heater Not Working",
                    unit: "Unit A-1-3",
                    worker: "Ravi Kumar",
                    status: heaterStatus,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),

      child: ChoiceChip(
        label: Text(text),

        selected: selectedFilter == text,

        onSelected: (value) {
          setState(() {
            selectedFilter = text;
          });
        },
      ),
    );
  }

  Widget buildRequestCard({
    required String title,
    required String unit,
    required String worker,
    required String status,
  }) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: const Icon(Icons.build),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [Text(unit), Text(worker)],
        ),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          decoration: BoxDecoration(
            color: getStatusColor(status).withOpacity(0.15),

            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            status,
            style: TextStyle(
              color: getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
