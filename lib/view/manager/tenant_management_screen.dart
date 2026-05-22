import 'package:flutter/material.dart';

class TenantManagementScreen extends StatefulWidget {
  const TenantManagementScreen({super.key});

  @override
  State<TenantManagementScreen> createState() => _TenantManagementScreenState();
}

class _TenantManagementScreenState extends State<TenantManagementScreen> {
  final TextEditingController tenantController = TextEditingController();

  List<String> tenants = ["John Tan", "Amy Lee", "Kevin Lim", "Sarah Wong"];

  void addTenant() {
    if (tenantController.text.isNotEmpty) {
      setState(() {
        tenants.add(tenantController.text);
      });

      tenantController.clear();
    }
  }

  void removeTenant(int index) {
    setState(() {
      tenants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tenant Management"), centerTitle: true),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            TextField(
              controller: tenantController,

              decoration: InputDecoration(
                labelText: "Tenant Name",

                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 15),

            SizedBox(
              width: double.infinity,
              height: 50,

              child: ElevatedButton(
                onPressed: addTenant,

                child: const Text("Add Tenant"),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: tenants.length,

                itemBuilder: (context, index) {
                  return Card(
                    elevation: 3,

                    child: ListTile(
                      leading: const Icon(Icons.person),

                      title: Text(tenants[index]),

                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),

                        onPressed: () {
                          removeTenant(index);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
