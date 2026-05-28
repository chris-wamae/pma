import 'package:flutter/material.dart';

class TenantDocumentPage extends StatelessWidget {
  const TenantDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          "My Documents",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF0A4E9A),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle("Legal & Contracts"),
          _buildDocTile(
            context,
            "Tenancy Agreement.pdf",
            "Signed on 12 Dec 2023",
            Icons.description,
          ),
          _buildDocTile(
            context,
            "House Rules & Regulations.pdf",
            "Updated 2 months ago",
            Icons.gavel,
          ),

          const SizedBox(height: 20),
          _buildSectionTitle("Financial Receipts"),
          _buildDocTile(
            context,
            "Receipt_May_2024.pdf",
            "24 May 2024",
            Icons.receipt,
          ),
          _buildDocTile(
            context,
            "Receipt_April_2024.pdf",
            "05 Apr 2024",
            Icons.receipt,
          ),

          const SizedBox(height: 20),
          _buildSectionTitle("Notices"),
          _buildDocTile(
            context,
            "Maintenance_Notice.pdf",
            "Air-cond service schedule",
            Icons.campaign,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blue[900],
        ),
      ),
    );
  }

  Widget _buildDocTile(
    BuildContext context,
    String fileName,
    String subtitle,
    IconData icon,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[50],
          child: Icon(icon, color: const Color(0xFF0A4E9A)),
        ),
        title: Text(
          fileName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.download_rounded, color: Colors.grey),
        onTap: () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Downloading $fileName...")));
        },
      ),
    );
  }
}
