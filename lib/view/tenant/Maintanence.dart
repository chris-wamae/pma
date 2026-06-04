import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  String selectedCategory = 'Plumbing';
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submitRequest() async {
    final String description = _descriptionController.text.trim();

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please describe the issue.")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 🕵️ 抓取當前登入的用戶對象
      final User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("No user logged in. Please log in first.");
      }

      // 🏷️ 處理動態用戶名：displayName -> Email -> 匿名租客
      String dynamicName =
          user.displayName ??
          (user.email != null ? user.email!.split('@')[0] : "Tenant");

      // 🛰️ 發送到 Firebase 專屬維修集合
      await FirebaseFirestore.instance.collection('maintenance_requests').add({
        'tenantId': user.uid, // 動態 UID
        'tenantName': dynamicName, // 動態用戶名
        'category': selectedCategory, // 下拉選單值
        'description': description, // 輸入框內容
        'status': 'pending', // 初始狀態
        'createdAt': FieldValue.serverTimestamp(),
        'cost': 0,
        'email': user.email ?? 'No Email', // 多存一個 email 方便 Manager 聯絡
      });

      if (!mounted) return;

      // 🟢 成功回饋
      _showSuccessDialog();
    } catch (e) {
      if (!mounted) return;
      _showErrorDialog(e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Icon(Icons.check_circle, color: Colors.green, size: 40),
        content: const Text(
          "Maintenance Request submitted successfully! Manager will be notified.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // 關閉 Dialog
              Navigator.pop(context); // 返回 Dashboard
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Submission Failed"),
        content: Text("Error: $error"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Maintenance Request"),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Issue Category",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "What needs fixing?",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitRequest,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4E9A),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Request",
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedCategory,
          items: <String>[
            'Plumbing',
            'Electrical',
            'Furniture',
            'Others',
          ].map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(),
          onChanged: (v) => setState(() => selectedCategory = v!),
        ),
      ),
    );
  }
}
