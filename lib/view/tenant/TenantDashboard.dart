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

  @override
  Widget build(BuildContext context) {
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
            _buildInfoCard("Tenancy Information", [
              "Tenancy Code: PMA-T-9921",
              "Tenancy Period: 2024 - 2025",
            ]),
            const SizedBox(height: 20),
            const Text(
              "My Invoices",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // 💡 核心改動：使用 StreamBuilder 即時監聽與計算當前用戶的帳單金額
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('invoices')
                  .where(
                    'tenantId',
                    isEqualTo: FirebaseAuth.instance.currentUser?.uid,
                  )
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
                          // 🔴 動態顯示未付總額
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
                          // 🟢 動態顯示已付總額
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
                                    builder: (context) => InvoiceDetailPage(
                                      amountToPay: totalUnpaid,
                                    ), // 👈 傳遞最新未付總額
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
                                  ? null // 💡 若已付清，按鈕自動變灰無法重複點擊
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              InvoiceDetailPage(
                                                amountToPay: totalUnpaid,
                                              ), // 👈 傳遞最新未付總額
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

            // 💡 優化佈局比例後的 GridView，確保 6 個按鈕完美顯現
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2, // 一行 2 個
              crossAxisSpacing: 12, // 左右間距
              mainAxisSpacing: 12, // 上下間距
              childAspectRatio: 2.3, // 調整比例讓按鈕扁一點，釋放空間
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
            const SizedBox(height: 20), // 底部留白
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

  Widget _buildInfoCard(String title, List<String> lines) {
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
