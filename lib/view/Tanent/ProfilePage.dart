import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Profile"),
        backgroundColor: const Color(0xFF0A4E9A),
        elevation: 0,
      ),
      body: Column(
        children: [
          // 頂部頭像區
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFF0A4E9A),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            padding: const EdgeInsets.only(bottom: 30),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 60, color: Color(0xFF0A4E9A)),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Xiao Xuan", // 這裡可以改成你的名字
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Unit A-12-03 | Sky Residence",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 選項列表
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildProfileItem(Icons.edit, "Edit Profile", () {}),
                _buildProfileItem(Icons.notifications, "Notifications", () {}),
                _buildProfileItem(Icons.security, "Security Settings", () {}),
                _buildProfileItem(Icons.help_outline, "Help Support", () {}),
                const Divider(),
                _buildProfileItem(Icons.logout, "Logout", () {
                  // 顯示登出提示
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Logged out successfully!")),
                  );
                }, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem(
    IconData icon,
    String title,
    VoidCallback onTap, {
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }
}
