import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class InvoiceDetailPage extends StatelessWidget {
  final double amountToPay; // 💡 接收從 Dashboard 帶過來的真實動態金額

  // 構造函數：給予 amountToPay 預設值 0.0，這樣從 "View Details" 進來不傳參也不會報錯
  const InvoiceDetailPage({super.key, this.amountToPay = 0.0});

  // 🔄 處理 Firebase 更新為 paid 的核心函式
  Future<void> _updateInvoiceStatusInFirebase(BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      // 1. 搜尋該登入用戶所有處於 unpaid 狀態的帳單
      final snapshot = await FirebaseFirestore.instance
          .collection('invoices')
          .where('tenantId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'unpaid')
          .get();

      // 2. 批次將它們全部更新為 paid 狀態
      for (var doc in snapshot.docs) {
        await FirebaseFirestore.instance
            .collection('invoices')
            .doc(doc.id)
            .update({'status': 'paid'});
      }
    } catch (e) {
      debugPrint("Error updating invoices: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Invoice Details",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: amountToPay > 0
                    ? Colors.red[50]
                    : Colors.green[50], // 💡 若付清了卡片自動轉綠色
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: amountToPay > 0
                      ? Colors.red[100]!
                      : Colors.green[100]!,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amountToPay > 0 ? "Total Unpaid" : "All Bills Settled",
                        style: TextStyle(
                          color: amountToPay > 0 ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "RM ${amountToPay.toStringAsFixed(2)}", // 👈 顯示實時金額
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Icon(
                    amountToPay > 0 ? Icons.receipt_long : Icons.check_circle,
                    size: 40,
                    color: amountToPay > 0 ? Colors.red : Colors.green,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            const Text(
              "Breakdown",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            // 費用明細列表
            _buildPriceItem("Monthly Rental", "RM 1,000.00", isPaid: true),
            _buildPriceItem(
              "Water Bill (May)",
              "RM 45.50",
              isPaid: amountToPay <= 0,
            ), // 連動狀態
            _buildPriceItem(
              "Electricity (May)",
              "RM 185.00",
              isPaid: amountToPay <= 0,
            ),
            _buildPriceItem(
              "Maintenance Fee",
              "RM 19.50",
              isPaid: amountToPay <= 0,
            ),

            const Divider(height: 40),

            // 支付說明
            const Text(
              "Payment Instructions",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Please settle your outstanding bills by the 7th of every month to avoid late payment penalties. You can pay via FPX, E-Wallet or Credit Card.",
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0A4E9A),
              padding: const EdgeInsets.symmetric(vertical: 15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: amountToPay <= 0
                ? null // 💡 如果沒有未付金額，按鈕禁用
                : () {
                    _showPaymentSelection(context);
                  },
            child: Text(
              amountToPay > 0
                  ? "Pay Outstanding (RM ${amountToPay.toStringAsFixed(2)})"
                  : "Fully Paid",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showPaymentSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Select Payment Method",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildPaymentOption(
                context,
                Icons.account_balance,
                "Online Banking (FPX)",
              ),
              const Divider(),
              _buildPaymentOption(
                context,
                Icons.account_balance_wallet,
                "Touch 'n Go eWallet",
              ),
              const Divider(),
              _buildPaymentOption(
                context,
                Icons.credit_card,
                "Credit / Debit Card",
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    IconData icon,
    String label,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: const Color(0xFF0A4E9A)),
      ),
      title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () async {
        Navigator.pop(context); // 關閉付款選單 BottomSheet

        // ⚡ 核心連動：使用者點擊任意選項後，背景非同步去更新 Firebase
        await _updateInvoiceStatusInFirebase(context);

        if (!context.mounted) return;
        _showPaymentSuccess(context); // 顯示原本寫好的漂亮綠色打勾視窗
      },
    );
  }

  Widget _buildPriceItem(String title, String price, {required bool isPaid}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                isPaid ? "Paid" : "Pending",
                style: TextStyle(
                  color: isPaid ? Colors.green : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showPaymentSuccess(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Icon(Icons.check_circle, color: Colors.green, size: 70),
        content: const Text(
          "Payment Successful!\n\nYour transaction has been processed and your receipt will be generated shortly.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: TextButton(
              onPressed: () {
                Navigator.pop(context); // 關閉對話方塊
                Navigator.pop(context); // 退回首頁 Dashboard
              },
              child: const Text(
                "Back to Home",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
