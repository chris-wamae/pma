import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pma/view/manager/request_details_screen.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  String pipeStatus = "In Progress";
  String aircondStatus = "In Progress";
  String doorStatus = "Completed";
  String heaterStatus = "Completed";

  String selectedFilter = "All";

  String searchText = "";

  final TextEditingController searchController = TextEditingController();

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case "pending":
        return Colors.orange;

      case "in progress":
        return Colors.blue;

      case "completed":
        return Colors.green;

      case "urgent":
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Work Progress"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: searchController,

              decoration: InputDecoration(
                hintText: "Search request...",
                prefixIcon: const Icon(Icons.search),

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value.toLowerCase();
                });
              },
            ),

            const SizedBox(height: 15),

            SingleChildScrollView(
              scrollDirection: Axis.horizontal,

              child: Row(
                children: [
                  filterButton("All"),

                  filterButton("Pending"),

                  filterButton("In Progress"),

                  filterButton("Completed"),

                  filterButton("Urgent"),
                ],
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('maintenance_requests')
                    .orderBy('createdAt', descending: true)
                    .snapshots(),

                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final docs = snapshot.data!.docs;
                  final filteredDocs = docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;

                    final status = (data["status"] ?? "pending")
                        .toString()
                        .toLowerCase();

                    if (selectedFilter == "All") {
                      return true;
                    }

                    if (selectedFilter == "Pending") {
                      return status == "pending";
                    }

                    if (selectedFilter == "In Progress") {
                      return status == "in progress";
                    }

                    if (selectedFilter == "Completed") {
                      return status == "completed";
                    }

                    if (selectedFilter == "Urgent") {
                      return status == "urgent";
                    }

                    return true;
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredDocs.length,
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];

                      final data = doc.data() as Map<String, dynamic>;

                      return buildRequestCard(
                        docId: doc.id,
                        title: data["category"] ?? "Request",
                        unit: data["tenantName"] ?? "Tenant",
                        worker: data["email"] ?? "",
                        status: (data["status"] ?? "pending").toString(),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget filterButton(String text) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),

      child: ChoiceChip(
        label: Text(text),

        selected: selectedFilter == text,

        onSelected: (value) {
          setState(() {
            selectedFilter = text;
          });
        },
      ),
    );
  }

  bool shouldShow(String status) {
    if (selectedFilter == "All") {
      return true;
    }

    return selectedFilter == status;
  }

  Widget buildRequestCard({
    required String docId,
    required String title,
    required String unit,
    required String worker,
    required String status,
  }) {
    return Card(
      elevation: 3,

      margin: const EdgeInsets.only(bottom: 12),

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

      child: ListTile(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  RequestDetailsScreen(docId: docId, currentStatus: status),
            ),
          );
        },

        leading: const Icon(Icons.build),

        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),

        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),

          decoration: BoxDecoration(
            color: getStatusColor(status).withOpacity(0.15),

            borderRadius: BorderRadius.circular(8),
          ),

          child: Text(
            status,
            style: TextStyle(
              color: getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
