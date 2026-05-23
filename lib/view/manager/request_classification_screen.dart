import 'package:flutter/material.dart';

class RequestClassificationScreen extends StatefulWidget {
  const RequestClassificationScreen({super.key});

  @override
  State<RequestClassificationScreen> createState() =>
      _RequestClassificationScreenState();
}

class _RequestClassificationScreenState
    extends State<RequestClassificationScreen> {
  List<Map<String, dynamic>> categories = [
    {"title": "Urgent", "count": "5 Requests", "icon": Icons.warning},
    {"title": "High", "count": "7 Requests", "icon": Icons.priority_high},
    {
      "title": "Normal",
      "count": "9 Requests",
      "icon": Icons.check_circle_outline,
    },
    {"title": "Low", "count": "3 Requests", "icon": Icons.arrow_downward},
    {"title": "All Requests", "count": "24 Requests", "icon": Icons.list},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Request Classification"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView.builder(
          itemCount: categories.length,

          itemBuilder: (context, index) {
            return classificationTile(
              context,
              categories[index]["title"],
              categories[index]["count"],
              categories[index]["icon"],
            );
          },
        ),
      ),
    );
  }

  Widget classificationTile(
    BuildContext context,
    String title,
    String count,
    IconData icon,
  ) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 10),

      child: ListTile(
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("$title selected")));
        },

        leading: Icon(icon),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(count),

        trailing: const Icon(Icons.arrow_forward_ios),
      ),
    );
  }
}
