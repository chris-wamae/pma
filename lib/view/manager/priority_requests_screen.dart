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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                filterButton("All"),
                filterButton("Urgent"),
                filterButton("High"),
                filterButton("Normal"),
                filterButton("Low"),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  requestCard(
                    "Leaking Pipe in Kitchen",
                    "Unit A-3-1",
                    "Urgent",
                    Colors.red,
                  ),

                  requestCard(
                    "Gas Smell in Unit",
                    "Unit B-1-4",
                    "Urgent",
                    Colors.red,
                  ),

                  requestCard(
                    "No Water Supply",
                    "Unit C-3-2",
                    "High",
                    Colors.orange,
                  ),

                  requestCard(
                    "Electricity Trip Issue",
                    "Unit A-2-3",
                    "High",
                    Colors.orange,
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
