import 'package:flutter/material.dart';
import 'Messagingscreen.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      // 1. 顶部栏 (还原草图中的 Logo 和 Profile Pic)
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
          "Welcome! User 12345",
          style: TextStyle(fontSize: 16),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 2. 租约信息卡 (Tenancy Info Box)
            _buildInfoCard("Tenancy Information", [
              "Tenancy Code: PMA-T-9921",
              "Tenancy Period: 2024 - 2025",
            ]),
            const SizedBox(height: 20),

            // 3. 账单概览 (My Invoices Section)
            const Text(
              "My Invoices",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
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
                      _buildInvoiceStat("Unpaid", "RM 250.00", Colors.red),
                      Container(width: 1, height: 40, color: Colors.grey[300]),
                      _buildInvoiceStat("Paid", "RM 1200.00", Colors.green),
                    ],
                  ),
                  const Divider(height: 30),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
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
                          onPressed: () {},
                          child: const Text("Pay Now"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 4. 快捷功能区 (Quick Actions 网格布局)
            const Text(
              "Quick Actions",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton(Icons.build, "Maintenance"),
                _buildActionButton(Icons.warning, "Report"),
                _buildActionButton(Icons.description, "Documents"),
                _buildActionButton(Icons.gavel, "House Rules"),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MessagingScreen(),
                      ),
                    );
                  },
                  child: _buildActionButton(Icons.message, "Messaging"),
                ),
              ],
            ),
          ],
        ),
      ),
      // 5. 底部导航栏 (还原草图底部的 Home, Wallet, Tickets, Profile)
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF0A4E9A),
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
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

  // 信息卡辅助组件
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
        children: lines
            .map((line) => Text(line, style: const TextStyle(height: 1.8)))
            .toList(),
      ),
    );
  }

  // 账单统计辅助组件
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

  // 按钮辅助组件
  Widget _buildActionButton(IconData icon, String label) {
    return Container(
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
    );
  }
}
