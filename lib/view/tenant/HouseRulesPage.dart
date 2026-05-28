import 'package:flutter/material.dart';

class HouseRulesPage extends StatelessWidget {
  const HouseRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("House Rules", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildRuleItem(
            "1. Noise Level",
            "Please keep noise to a minimum between 10:00 PM and 8:00 AM.",
          ),
          _buildRuleItem(
            "2. Smoking Policy",
            "Smoking is strictly prohibited inside the premises.",
          ),
          _buildRuleItem(
            "3. Waste Management",
            "Please dispose of trash in the designated bins at the refuse chamber.",
          ),
          _buildRuleItem(
            "4. Common Areas",
            "Keep the hallways and common areas clear of personal belongings.",
          ),
          _buildRuleItem(
            "5. Visitors",
            "Visitors must register at the guard house and leave by 11:00 PM.",
          ),
          _buildRuleItem(
            "6. Maintenance",
            "Report any leakages or damages immediately via the Maintenance section.",
          ),
        ],
      ),
    );
  }

  Widget _buildRuleItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0A4E9A),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            description,
            style: TextStyle(
              // 这里去掉了前面的 const，修复了报错
              fontSize: 14,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
          const Divider(height: 30),
        ],
      ),
    );
  }
}
