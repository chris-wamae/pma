import 'package:flutter/material.dart';

class TenantManagementScreen extends StatefulWidget {
  const TenantManagementScreen({super.key});

  @override
  State<TenantManagementScreen> createState() => _TenantManagementScreenState();
}

class _TenantManagementScreenState extends State<TenantManagementScreen> {
  final TextEditingController tenantController = TextEditingController();

  List<Map<String, dynamic>> tenants = [
    {"name": "John Tan", "status": "Pending"},
    {"name": "Amy Lee", "status": "Pending"},
    {"name": "Kevin Lim", "status": "Accepted"},
    {"name": "Sarah Wong", "status": "Pending"},
  ];

  void addTenant() {
    if (tenantController.text.isNotEmpty) {
      setState(() {
        tenants.add({"name": tenantController.text, "status": "Pending"});
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

                      title: Text(tenants[index]["name"]),

                      subtitle: Text("Status: ${tenants[index]["status"]}"),

                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,

                        children: [
                          if (tenants[index]["status"] == "Pending")
                            IconButton(
                              icon: const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                              ),

                              onPressed: () {
                                setState(() {
                                  tenants[index]["status"] = "Accepted";
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Tenancy accepted"),
                                  ),
                                );
                              },
                            ),

                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),

                            onPressed: () {
                              removeTenant(index);
                            },
                          ),
                        ],
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
