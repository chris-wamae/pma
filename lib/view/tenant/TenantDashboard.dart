import 'package:flutter/material.dart';
import 'package:pma/view/tenant/TenantDocumentPage.dart';
import 'Messagingscreen.dart';
import 'Maintanence.dart';
import 'ReportPage.dart';
import 'TicketPage.dart';
import 'ProfilePage.dart';
import 'InvoiceDetail.dart';
import 'HouseRulesPage.dart';
import 'ChatListScreen.dart';
import 'RatingPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  // 🔄 新增：處理點擊接受租約的 Firebase 更新函式
  Future<void> _acceptTenancy(String docId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance
          .collection('tenancies')
          .doc(docId)
          .update({'status': 'accepted'});

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tenancy contract accepted successfully!"),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to accept contract: $e"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A4E9A),
        elevation: 0,
        leading: const Padding(
          padding: EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: Text(
              "PMA",
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        title: const Text(
          "Welcome! Xiao Xuan",
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ProfilePage()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: NetworkImage(
                  'https://via.placeholder.com/150',
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 💡 核心改動 1：動態監聽並顯示租約狀態與 Accept 按鈕
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tenancies')
                  .where('tenantId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Card(
                    child: ListTile(title: Text("Loading tenancy details...")),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  // 萬一沒資料，顯示備用靜態卡片
                  return _buildStaticInfoCard("Tenancy Information", [
                    "No tenancy record found.",
                  ]);
                }

                final doc = snapshot.data!.docs.first;
                final data = doc.data() as Map<String, dynamic>;
                final String status = data['status'] ?? 'pending';
                final String code = data['tenancyCode'] ?? 'PMA-T-9921';
                final String period = data['tenancyPeriod'] ?? '2024 - 2025';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: status == 'accepted'
                        ? Colors.blue[50]
                        : Colors.orange[50], // 狀態不同顏色不同
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: status == 'accepted'
                          ? Colors.blue[100]!
                          : Colors.orange[100]!,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Tenancy Information",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0A4E9A),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: status == 'accepted'
                                  ? Colors.green
                                  : Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              status.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 🔄 依據狀態顯示內容
                      if (status == 'accepted') ...[
                        Text(
                          "Tenancy Code: $code",
                          style: const TextStyle(height: 1.5),
                        ),
                        Text(
                          "Tenancy Period: $period",
                          style: const TextStyle(height: 1.5),
                        ),
                      ] else ...[
                        const Text(
                          "Your tenancy contract is ready. Please review and accept to active your account.",
                          style: TextStyle(
                            height: 1.4,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 40,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green[700],
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            icon: const Icon(Icons.gavel, size: 16),
                            label: const Text(
                              "ACCEPT TENANCY CONTRACT",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            onPressed: () => _acceptTenancy(
                              doc.id,
                              context,
                            ), // ⚡ 點擊更新 Firebase
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),
            const Text(
              "My Invoices",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 💡 核心：使用 StreamBuilder 即時監聽與動態累加計算帳單金額
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('invoices')
                  .where('tenantId', isEqualTo: currentUserId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                double totalUnpaid = 0.0;
                double totalPaid = 0.0;

                if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final double amount = (data['amount'] ?? 0.0).toDouble();
                    final String status = data['status'] ?? 'unpaid';

                    if (status == 'paid') {
                      totalPaid += amount;
                    } else {
                      totalUnpaid += amount;
                    }
                  }
                }

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildInvoiceStat(
                            "Unpaid",
                            "RM ${totalUnpaid.toStringAsFixed(2)}",
                            Colors.red,
                          ),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          _buildInvoiceStat(
                            "Paid",
                            "RM ${totalPaid.toStringAsFixed(2)}",
                            Colors.green,
                          ),
                        ],
                      ),
                      const Divider(height: 30),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const InvoiceDetailPage(),
                                  ),
                                );
                              },
                              child: const Text("View Details"),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[900],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: totalUnpaid <= 0
                                  ? null
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InvoiceDetailPage(
                                                amountToPay: totalUnpaid,
                                              ),
                                        ),
                                      );
                                    },
                              child: const Text("Pay Now"),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.3,
              children: [
                _buildActionButton(Icons.build, "Maintenance", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintenancePage(),
                    ),
                  );
                }),
                _buildActionButton(Icons.star, "Rate House", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const RatingPage()),
                  );
                }),
                _buildActionButton(Icons.warning, "Report", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ReportPage()),
                  );
                }),
                _buildActionButton(Icons.description, "Documents", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TenantDocumentPage(),
                    ),
                  );
                }),
                _buildActionButton(Icons.gavel, "House Rules", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HouseRulesPage(),
                    ),
                  );
                }),
                _buildActionButton(Icons.message, "Messaging", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChatListScreen(),
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0A4E9A),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const TicketPage()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfilePage()),
            );
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: 'Wallet',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }

  // 靜態備用資訊卡片
  Widget _buildStaticInfoCard(String title, List<String> lines) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A4E9A),
            ),
          ),
          const SizedBox(height: 8),
          ...lines.map(
            (line) => Text(line, style: const TextStyle(height: 1.5)),
          ),
        ],
      ),
    );
  }

  Widget _buildInvoiceStat(String label, String amount, Color color) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 5),
        Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF0A4E9A), size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}
