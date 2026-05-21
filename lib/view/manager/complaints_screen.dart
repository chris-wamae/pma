import 'package:flutter/material.dart';

class ComplaintsScreen extends StatelessWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Complaints")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            complaintCard(
              "Noise Complaint",
              "Unit B-2-4",
              "Open",
              Colors.orange,
            ),

            complaintCard(
              "Poor Cleanliness",
              "Unit C-1-2",
              "Open",
              Colors.orange,
            ),

            complaintCard("Parking Issue", "Block D", "Resolved", Colors.green),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Report Generated Successfully"),
                    ),
                  );
                },

                child: const Text("Generate Report"),
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
    String status,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        title: Text(title),

        subtitle: Text(location),

        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
