import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TicketPage extends StatelessWidget {
  const TicketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        title: const Text("Maintenance Tickets"),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
      ),
      body: currentUserId == null
          ? const Center(child: Text("Please log in first."))
          : StreamBuilder<QuerySnapshot>(
              // 🛰️ 實時監聽 Chris 指定的維修集合，並且只抓當前登入租客的單子
              stream: FirebaseFirestore.instance
                  .collection('property_ratings') // ⚠️ 根據 Chris 的截圖，維修數據在這個集合
                  .where('tenantId', isEqualTo: currentUserId)
                  // 如果你在 MaintenancePage 提交時有存 tenantId 的話就可以這樣篩選
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError)
                  return const Center(child: Text("Error loading tickets"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final tickets = snapshot.data?.docs ?? [];

                if (tickets.isEmpty) {
                  return const Center(
                    child: Text(
                      "No active maintenance tickets found.",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: tickets.length,
                  itemBuilder: (context, index) {
                    final data = tickets[index].data() as Map<String, dynamic>;
                    final String title = data['title'] ?? 'Maintenance Request';
                    final String description =
                        data['description'] ?? 'No description provided';
                    final String status =
                        data['status'] ??
                        'pending'; // pending, progress, completed
                    final int cost = data['cost'] ?? 0;

                    return _buildTicketCard(title, description, status, cost);
                  },
                );
              },
            ),
    );
  }

  // 🎨 構建每一個維修單的卡片與進度條
  Widget _buildTicketCard(
    String title,
    String description,
    String status,
    int cost,
  ) {
    // 根據狀態計算進度條百分比與顏色
    double progress = 0.2;
    Color statusColor = Colors.orange;
    String statusText = "Pending";

    if (status == 'progress' || status == 'In Progress') {
      progress = 0.6;
      statusColor = Colors.blue;
      statusText = "In Progress";
    } else if (status == 'completed' || status == 'Completed') {
      progress = 1.0;
      statusColor = Colors.green;
      statusText = "Completed";
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),
            if (cost > 0) ...[
              const SizedBox(height: 8),
              Text(
                "Estimated Cost: RM $cost",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
            const SizedBox(height: 16),

            // 📊 進度條 UI
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      "Submitted",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      "Fixing",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    Text(
                      "Done",
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.grey[200],
                  color: statusColor,
                  minHeight: 6,
                  borderRadius: BorderRadius.circular(3),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
