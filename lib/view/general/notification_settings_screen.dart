import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  final bool maintenanceUpdates;
  final bool rentReminders;
  final bool announcements;
  final bool messages;
  final bool systemUpdates;

  const NotificationSettingsScreen({
    super.key,
    required this.maintenanceUpdates,
    required this.rentReminders,
    required this.announcements,
    required this.messages,
    required this.systemUpdates,
  });

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  late bool maintenanceUpdates;
  late bool rentReminders;
  late bool announcements;
  late bool messages;
  late bool systemUpdates;

  @override
  void initState() {
    super.initState();

    maintenanceUpdates = widget.maintenanceUpdates;
    rentReminders = widget.rentReminders;
    announcements = widget.announcements;
    messages = widget.messages;
    systemUpdates = widget.systemUpdates;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notification Settings"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            buildSwitchTile("Maintenance Updates", maintenanceUpdates, (value) {
              setState(() {
                maintenanceUpdates = value;
              });
            }),

            buildSwitchTile("Rent Reminders", rentReminders, (value) {
              setState(() {
                rentReminders = value;
              });
            }),

            buildSwitchTile("Announcements", announcements, (value) {
              setState(() {
                announcements = value;
              });
            }),

            buildSwitchTile("Messages", messages, (value) {
              setState(() {
                messages = value;
              });
            }),

            buildSwitchTile("System Updates", systemUpdates, (value) {
              setState(() {
                systemUpdates = value;
              });
            }),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, {
                    "maintenance": maintenanceUpdates,
                    "rent": rentReminders,
                    "announcement": announcements,
                    "messages": messages,
                    "system": systemUpdates,
                  });
                },

                child: const Text("Save Settings"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSwitchTile(
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),

      child: SwitchListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
