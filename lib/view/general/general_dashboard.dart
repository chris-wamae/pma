import 'package:flutter/material.dart';
import 'notification_screen.dart';

class GeneralDashboard extends StatelessWidget {
  const GeneralDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("General Functions"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              elevation: 3,

              child: ListTile(
                leading: const Icon(Icons.notifications, color: Colors.orange),

                title: const Text(
                  "Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                subtitle: const Text("View notifications and alerts"),

                trailing: const Icon(Icons.arrow_forward_ios),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const NotificationScreen(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
