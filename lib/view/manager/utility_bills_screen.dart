import 'package:flutter/material.dart';

class UtilityBillsScreen extends StatefulWidget {
  const UtilityBillsScreen({super.key});

  @override
  State<UtilityBillsScreen> createState() => _UtilityBillsScreenState();
}

class _UtilityBillsScreenState extends State<UtilityBillsScreen> {
  final TextEditingController electricityController = TextEditingController();

  final TextEditingController waterController = TextEditingController();

  final TextEditingController tenantController = TextEditingController();

  String result = "";

  void calculateBill() {
    double electricity = double.tryParse(electricityController.text) ?? 0;

    double water = double.tryParse(waterController.text) ?? 0;

    int tenants = int.tryParse(tenantController.text) ?? 1;

    double total = electricity + water;
    double share = total / tenants;

    setState(() {
      result = "Each tenant should pay RM ${share.toStringAsFixed(2)}";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shared Utility Bills"),
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: ListView(
          children: [
            const Text(
              "Electricity Bill (RM)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: electricityController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text(
              "Water Bill (RM)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: waterController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 20),

            const Text(
              "Number of Tenants",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            TextField(
              controller: tenantController,
              keyboardType: TextInputType.number,

              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),

            const SizedBox(height: 30),

            SizedBox(
              height: 50,

              child: ElevatedButton(
                onPressed: calculateBill,
                child: const Text("Generate Split Bill"),
              ),
            ),

            const SizedBox(height: 25),

            Card(
              elevation: 3,

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Text(
                  result,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
