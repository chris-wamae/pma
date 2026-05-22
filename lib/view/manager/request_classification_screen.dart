import 'package:flutter/material.dart';

class RequestClassificationScreen extends StatelessWidget {
  const RequestClassificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Classification"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            classificationTile("Urgent", "5 Requests", Icons.warning),

            classificationTile("High", "7 Requests", Icons.priority_high),

            classificationTile(
              "Normal",
              "9 Requests",
              Icons.check_circle_outline,
            ),

            classificationTile("Low", "3 Requests", Icons.arrow_downward),

            classificationTile("All Requests", "24 Requests", Icons.list),
          ],
        ),
      ),
    );
  }

  Widget classificationTile(String title, String count, IconData icon) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        leading: Icon(icon),

        title: Text(title),

        subtitle: Text(count),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
