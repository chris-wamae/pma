import 'package:flutter/material.dart';

class PriorityRequestsScreen extends StatefulWidget {
  const PriorityRequestsScreen({super.key});

  @override
  State<PriorityRequestsScreen> createState() => _PriorityRequestsScreenState();
}

class _PriorityRequestsScreenState extends State<PriorityRequestsScreen> {
  String selectedFilter = "All";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Priority Requests"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  filterButton("All"),
                  const SizedBox(width: 8),

                  filterButton("Urgent"),
                  const SizedBox(width: 8),

                  filterButton("High"),
                  const SizedBox(width: 8),

                  filterButton("Normal"),
                  const SizedBox(width: 8),

                  filterButton("Low"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  if (selectedFilter == "All" || selectedFilter == "Urgent")
                    requestCard(
                      "Leaking Pipe in Kitchen",
                      "Unit A-3-1",
                      "Urgent",
                      Colors.red,
                    ),

                  if (selectedFilter == "All" || selectedFilter == "Urgent")
                    requestCard(
                      "Gas Smell in Unit",
                      "Unit B-1-4",
                      "Urgent",
                      Colors.red,
                    ),

                  if (selectedFilter == "All" || selectedFilter == "High")
                    requestCard(
                      "No Water Supply",
                      "Unit C-3-2",
                      "High",
                      Colors.orange,
                    ),

                  if (selectedFilter == "All" || selectedFilter == "High")
                    requestCard(
                      "Electricity Trip Issue",
                      "Unit A-2-3",
                      "High",
                      Colors.orange,
                    ),

                  if (selectedFilter == "All" || selectedFilter == "Normal")
                    requestCard(
                      "Broken Window",
                      "Unit D-2-1",
                      "Normal",
                      Colors.blue,
                    ),

                  if (selectedFilter == "All" || selectedFilter == "Low")
                    requestCard(
                      "Paint Touch Up",
                      "Unit C-1-5",
                      "Low",
                      Colors.green,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == label
            ? Colors.black
            : Colors.grey.shade300,

        foregroundColor: selectedFilter == label ? Colors.white : Colors.black,
      ),

      onPressed: () {
        setState(() {
          selectedFilter = label;
        });
      },

      child: Text(label),
    );
  }

  Widget requestCard(String title, String unit, String priority, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(unit),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            priority,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
