import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import 'property_list.dart';
import 'add_property.dart';
import 'edit_property.dart';
import '../general/file_management_screen.dart'; // Import FileManagementScreen
import '../tenant/ChatListScreen.dart';

class OwnerDashboard extends StatelessWidget {
  const OwnerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OwnerPropertyViewModel()..loadProperties(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Owner Dashboard'),
          actions: [
            IconButton(
              icon: const Icon(Icons.chat),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChatListScreen()),
                );
              },
            ),
          ],
        ),
        body: Consumer<OwnerPropertyViewModel>(builder: (context, vm, _) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());

          final propertyCount = vm.properties.length;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: dashboardBox(propertyCount.toString(), 'Properties', Colors.blue),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: dashboardBox('-', 'Tenants', Colors.green),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/owner/properties');
                        },
                        icon: const Icon(Icons.home),
                        label: const Text('View Properties'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => AddPropertyScreen(viewModel: Provider.of<OwnerPropertyViewModel>(context, listen: false))));
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Add Property'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FileManagementScreen(
                                entityId: 'owner_dashboard_id',
                                entityType: 'owner',
                                uploadedBy: 'current_user_id',
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.folder),
                        label: const Text('File Management'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ChatListScreen()),
                          );
                        },
                        icon: const Icon(Icons.chat),
                        label: const Text('Messaging'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                const Text('Recent Properties', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),

                ...vm.properties.take(5).map((p) => Card(
                      child: ListTile(
                        title: Text(p.name),
                        subtitle: Text(p.address ?? ''),
                        trailing: Text('${p.units} units'),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (_) => EditPropertyScreen(property: p, viewModel: vm)));
                        },
                      ),
                    )),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget dashboardBox(String number, String title, Color color) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(number, style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}
