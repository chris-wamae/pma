import 'package:flutter/material.dart';
import 'package:pma/view/tenant/ChatListScreen.dart';
import 'package:pma/view/tenant/TenantDocumentPage.dart';
import 'Messagingscreen.dart';
import 'Maintanence.dart';
import 'ReportPage.dart';
import 'TicketPage.dart';
import 'ProfilePage.dart';
import 'InvoiceDetail.dart';
import 'HouseRulesPage.dart';

class TenantDashboard extends StatelessWidget {
  const TenantDashboard({super.key});

  void _showChatSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Select Contact",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFF0A4E9A),
                  child: Icon(Icons.support_agent, color: Colors.white),
                ),
                title: const Text("Chat with Manager"),
                subtitle: const Text("For maintenance & general inquiries"),
                onTap: () {
                  Navigator.pop(context);
                  // 🚀 关键点：传参 manager_chats
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MessagingScreen(chatTarget: "manager_chats"),
                    ),
                  );
                },
              ),
              const Divider(),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.orange,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                title: const Text("Chat with Owner"),
                subtitle: const Text("For contract & payment issues"),
                onTap: () {
                  Navigator.pop(context);
                  // 🚀 关键点：传参 owner_chats
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const MessagingScreen(chatTarget: "owner_chats"),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

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
        title: const Text("Welcome! Xiao Xuan", style: TextStyle(fontSize: 16)),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InvoiceDetailPage(),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const InvoiceDetailPage(),
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
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 2.5,
              children: [
                _buildActionButton(Icons.build, "Maintenance", () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MaintenancePage(),
                    ),
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
                    MaterialPageRoute(builder: (context) => const ChatListScreen()),
                  );
                }),
              ],
            ),
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
        children: lines
            .map((line) => Text(line, style: const TextStyle(height: 1.8)))
            .toList(),
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
