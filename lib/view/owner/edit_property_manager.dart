import 'package:flutter/material.dart';
import '../../viewmodels/owner_property_viewmodel.dart';

class EditPropertyManagerScreen extends StatefulWidget {
  final String propertyId;
  final OwnerPropertyViewModel viewModel;

  const EditPropertyManagerScreen({super.key, required this.propertyId, required this.viewModel});

  @override
  State<EditPropertyManagerScreen> createState() => _EditPropertyManagerScreenState();
}

class _EditPropertyManagerScreenState extends State<EditPropertyManagerScreen> {
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.viewModel.loadManagersForProperty(widget.propertyId);
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Property Managers')),
      body: ListenableBuilder(
      // Using ListenableBuilder to react to ViewModel changes
      listenable: vm,
      builder: (context, child) {
        if (vm.isManagersLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Property Managers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              
              // Managers List
              if (vm.propertyManagers.isEmpty)
                const Text('No managers assigned to this property.')
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.propertyManagers.length,
                    itemBuilder: (context, index) {
                      final manager = vm.propertyManagers[index];
                      return Card(
                        child: ListTile(
                          title: Text(manager.name ?? 'Unknown'),
                          subtitle: Text(manager.email),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              final ok = await vm.removeManagerFromProperty(widget.propertyId, manager.uid);
                              if (!ok && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(vm.managerError ?? 'Failed to remove manager')),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 20),
              const Divider(),
              const SizedBox(height: 20),

              // Add Manager Section
              const Text(
                'Add New Manager',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Manager Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Email is required' : null,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () async {
                      final email = _emailController.text.trim();
                      if (email.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Please enter an email')),
                        );
                        return;
                      }

                      final ok = await vm.addManagerToProperty(widget.propertyId, email);
                      if (ok) {
                        _emailController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Manager added successfully')),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(vm.managerError ?? 'Failed to add manager')),
                        );
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ));
  }
}
