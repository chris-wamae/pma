import 'package:flutter/material.dart';
import 'notification_settings_screen.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  String selectedFilter = "All";

  bool maintenanceUpdates = true;
  bool rentReminders = true;
  bool announcements = true;
  bool messages = true;
  bool systemUpdates = false;

  final List<Map<String, dynamic>> notifications = [
    {
      "title": "New Maintenance Request",
      "message": "Leaking pipe in kitchen",
      "time": "2 min ago",
      "read": false,
      "important": true,
      "type": "maintenance",
    },
    {
      "title": "Rent Payment Reminder",
      "message": "Unit B-2-4 payment due",
      "time": "1 hour ago",
      "read": false,
      "important": false,
      "type": "rent",
    },
    {
      "title": "Announcement",
      "message": "Water supply interruption tomorrow",
      "time": "3 hours ago",
      "read": true,
      "important": true,
      "type": "announcement",
    },
    {
      "title": "Repair Completed",
      "message": "Aircond repair completed",
      "time": "Yesterday",
      "read": true,
      "important": false,
      "type": "maintenance",
    },
  ];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredNotifications = notifications.where((
      notification,
    ) {
      String type = notification["type"];

      if (type == "maintenance" && !maintenanceUpdates) return false;
      if (type == "rent" && !rentReminders) return false;
      if (type == "announcement" && !announcements) return false;
      if (type == "messages" && !messages) return false;
      if (type == "system" && !systemUpdates) return false;

      if (selectedFilter == "Unread") {
        return notification["read"] == false;
      }

      if (selectedFilter == "Important") {
        return notification["important"] == true;
      }

      return true;
    }).toList();

    int unreadCount = filteredNotifications
        .where((n) => n["read"] == false)
        .length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(Icons.done_all),

            onPressed: () {
              setState(() {
                for (var notification in notifications) {
                  notification["read"] = true;
                }
              });

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("All notifications marked as read"),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.settings),

            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NotificationSettingsScreen(
                    maintenanceUpdates: maintenanceUpdates,
                    rentReminders: rentReminders,
                    announcements: announcements,
                    messages: messages,
                    systemUpdates: systemUpdates,
                  ),
                ),
              );

              if (result != null) {
                setState(() {
                  maintenanceUpdates = result["maintenance"];
                  rentReminders = result["rent"];
                  announcements = result["announcement"];
                  messages = result["messages"];
                  systemUpdates = result["system"];
                });
              }
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              color: Colors.orange.shade50,

              child: ListTile(
                leading: const Icon(
                  Icons.notifications_active,
                  color: Colors.orange,
                ),

                title: const Text(
                  "Unread Notifications",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),

                trailing: CircleAvatar(child: Text(unreadCount.toString())),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                filterButton("All"),
                filterButton("Unread"),
                filterButton("Important"),
              ],
            ),

            const SizedBox(height: 15),

            Expanded(
              child: filteredNotifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No notifications available",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredNotifications.length,

                      itemBuilder: (context, index) {
                        final notification = filteredNotifications[index];

                        return Card(
                          color: notification["read"]
                              ? Colors.white
                              : Colors.orange.shade50,

                          child: ListTile(
                            leading: Icon(
                              notification["important"]
                                  ? Icons.priority_high
                                  : Icons.notifications,
                              color: notification["important"]
                                  ? Colors.red
                                  : Colors.blue,
                            ),

                            title: Text(
                              notification["title"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,

                              children: [
                                Text(notification["message"]),

                                const SizedBox(height: 4),

                                Text(
                                  notification["time"],
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),

                            onTap: () {
                              setState(() {
                                notification["read"] = true;
                              });

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(notification["title"])),
                              );
                            },
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
}
