import 'package:flutter/material.dart';

class RentCollectionScreen extends StatelessWidget {
  const RentCollectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rent Collection Status"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,

                  children: const [
                    Column(
                      children: [
                        Text(
                          "120",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Total Tenants"),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          "85",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Paid"),
                      ],
                    ),

                    Column(
                      children: [
                        Text(
                          "35",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Unpaid"),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            const Text(
              "Outstanding Payments",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            buildTenantCard(
              "Unit A-3-1",
              "RM 1,200",
              "Overdue 10 Days",
              Colors.red,
            ),

            buildTenantCard(
              "Unit B-2-4",
              "RM 1,200",
              "Overdue 5 Days",
              Colors.orange,
            ),

            buildTenantCard("Unit C-1-2", "RM 1,000", "Pending", Colors.blue),
          ],
        ),
      ),
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
