import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key});

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  bool isAnonymous = false;
  String selectedType = 'Noise';

  // ✅ 新增：用來抓取輸入框文字的控制器
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false; // 新增：防止重複點擊提交的狀態

  // ✅ 新增：提交投訴到 Firebase 的函數
  void _submitReportToFirebase() async {
    final String description = _descriptionController.text.trim();

    // 如果沒寫描述，彈出提示
    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the description")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. 獲取當前登入的租客 UID
      final String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

      // 2. 打包數據
      final Map<String, dynamic> reportData = {
        'tenantId': currentUserId ?? 'Unknown_Tenant',
        'type': selectedType,
        'isAnonymous': isAnonymous,
        'description': description,
        'status':
            'pending', // 🚀 預設狀態為 pending，Manager 審批後可以改成 investigating 或 resolved
        'timestamp': FieldValue.serverTimestamp(), // Firebase 伺服器時間
      };

      // 3. 上傳到 Firestore 的 complaints 集合
      await FirebaseFirestore.instance.collection('complaints').add(reportData);

      if (!mounted) return;

      // 4. 成功反饋
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isAnonymous
                ? "Anonymous report sent to Firebase!"
                : "Report sent to Firebase!",
          ),
        ),
      );

      Navigator.pop(context); // 關閉頁面返回 Dashboard
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to submit report: $e")));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _descriptionController.dispose(); // ✅ 銷毀控制器，釋放記憶體
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report an Issue"),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // 避免鍵盤彈起時造成溢出
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Violation Type",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              _buildDropdown(),
              const SizedBox(height: 20),

              // --- 實名/匿名 切換區塊 ---
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Report Anonymously",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: isAnonymous,
                    onChanged: (value) {
                      setState(() {
                        isAnonymous = value;
                      });
                    },
                  ),
                ],
              ),
              Text(
                isAnonymous
                    ? "Your identity will be hidden from the management."
                    : "Your name will be visible to the management.",
                style: TextStyle(
                  fontSize: 12,
                  color: isAnonymous ? Colors.orange : Colors.grey,
                ),
              ),

              // -----------------------
              const SizedBox(height: 20),
              const Text(
                "Description",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                // ✅ 綁定控制器
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: "Enter details (e.g. Unit number, time...)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : _submitReportToFirebase, // ✅ 點擊觸發上傳
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A4E9A),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Submit Report",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
          value: selectedType,
          items: <String>['Noise', 'Parking', 'Trash', 'Smoking', 'Others'].map(
            (String value) {
              return DropdownMenuItem<String>(value: value, child: Text(value));
            },
          ).toList(),
          onChanged: (newValue) {
            setState(() {
              selectedType = newValue!;
            });
          },
        ),
      ),
    );
  }
}
