import 'package:flutter/material.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("All"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Open"),
                  ),
                ),

                const SizedBox(width: 8),

                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text("Resolved"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView(
                children: [
                  complaintCard(
                    "Noise Complaint",
                    "Unit B-2-4",
                    "12 May 2025",
                    "Open",
                    Colors.orange,
                  ),

                  complaintCard(
                    "Poor Cleanliness",
                    "Unit C-1-2",
                    "11 May 2025",
                    "Open",
                    Colors.orange,
                  ),

                  complaintCard(
                    "Parking Issue",
                    "Block D",
                    "10 May 2025",
                    "Resolved",
                    Colors.green,
                  ),
                ],
              ),
            ),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report Generated Successfully"),
                    ),
                  );
                },

                icon: const Icon(Icons.description),

                label: const Text("Generate Report"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget complaintCard(
    String title,
    String location,
    String date,
    String status,
    Color color,
  ) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        leading: const Icon(Icons.report_problem),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text("$location • $date"),

        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
