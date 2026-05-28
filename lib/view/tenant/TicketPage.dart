import 'package:flutter/material.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    // fake ticket
    final List<Map<String, dynamic>> tickets = [
      {
        "id": "TK-8801",
        "type": "Maintenance",
        "title": "Leaking Pipe",
        "status": "In Progress",
        "date": "2024-05-20",
        "color": Colors.orange,
      },
      {
        "id": "TK-8750",
        "type": "Report",
        "title": "Noise Complaint",
        "status": "Pending",
        "date": "2024-05-22",
        "color": Colors.red,
      },
      {
        "id": "TK-8600",
        "type": "Maintenance",
        "title": "Aircon Cleaning",
        "status": "Completed",
        "date": "2024-05-10",
        "color": Colors.green,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tickets & Progress",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];
          // 強制轉換為 Color 類型，避免編譯器報錯
          final Color statusColor = ticket['color'] as Color;

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(
              bottom: 12,
            ), // 修正：從 .bottom 改為 .only(bottom: 12)
            child: ListTile(
              leading: Icon(Icons.confirmation_number, color: statusColor),
              title: Text(
                "${ticket['id']} - ${ticket['title']}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text("Date: ${ticket['date']} | ${ticket['type']}"),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  // 修正：使用 withAlpha 或 withValues 解決新版 Flutter 警告
                  color: statusColor.withAlpha(26),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  ticket['status'],
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
