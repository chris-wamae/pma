import 'package:flutter/material.dart';

class RentCollectionScreen extends StatefulWidget {
  const RentCollectionScreen({super.key});

  @override
  State<RentCollectionScreen> createState() => _RentCollectionScreenState();
}

class _RentCollectionScreenState extends State<RentCollectionScreen> {
  String selectedFilter = "All";

  final List<Map<String, dynamic>> tenants = [
    {"unit": "Unit A-3-1", "amount": 1200, "status": "Overdue"},
    {"unit": "Unit B-2-4", "amount": 1200, "status": "Pending"},
    {"unit": "Unit C-1-2", "amount": 1000, "status": "Paid"},
    {"unit": "Unit D-1-5", "amount": 1000, "status": "Paid"},
  ];

  bool shouldShow(String status) {
    if (selectedFilter == "All") {
      return true;
    }

    return selectedFilter == status;
  }

  Color getStatusColor(String status) {
    switch (status) {
      case "Paid":
        return Colors.green;

      case "Pending":
        return Colors.orange;

      case "Overdue":
        return Colors.red;

      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalTenants = tenants.length;

    final paidCount = tenants.where((t) => t["status"] == "Paid").length;

    final pendingCount = tenants.where((t) => t["status"] != "Paid").length;

    final totalRevenue = tenants.fold<int>(
      0,
      (sum, item) => sum + (item["amount"] as int),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Collection Status"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: [
                    summaryColumn("$totalTenants", "Tenants"),

                    summaryColumn("$paidCount", "Paid"),

                    summaryColumn("$pendingCount", "Unpaid"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Card(
              color: Colors.green.shade50,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,

                  children: [
                    const Text(
                      "Monthly Revenue",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    Text(
                      "RM $totalRevenue",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 15),

            Row(
              children: [
                Expanded(child: filterButton("All")),

                const SizedBox(width: 8),

                Expanded(child: filterButton("Paid")),

                const SizedBox(width: 8),

                Expanded(child: filterButton("Pending")),

                const SizedBox(width: 8),

                Expanded(child: filterButton("Overdue")),
              ],
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,

                itemBuilder: (context, index) {
                  final tenant = tenants[index];

                  if (!shouldShow(tenant["status"])) {
                    return const SizedBox();
                  }

                  return buildTenantCard(
                    tenant["unit"],
                    "RM ${tenant["amount"]}",
                    tenant["status"],
                    getStatusColor(tenant["status"]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget summaryColumn(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        Text(label),
      ],
    );
  }

  Widget filterButton(String text) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedFilter = text;
        });
      },

      style: ElevatedButton.styleFrom(
        backgroundColor: selectedFilter == text
            ? Colors.blue
            : Colors.grey.shade300,
      ),

      child: Text(text),
    );
  }

  Widget buildTenantCard(
    String unit,
    String amount,
    String status,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: ListTile(
        leading: const Icon(Icons.home),

        title: Text(unit, style: const TextStyle(fontWeight: FontWeight.bold)),

        subtitle: Text(amount),

        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
