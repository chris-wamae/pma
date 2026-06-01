import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import '../../models/property_model.dart';
import 'edit_property.dart';
import 'add_property.dart';

class PropertyListScreen extends StatefulWidget {
  const PropertyListScreen({super.key});

  @override
  State<PropertyListScreen> createState() => _PropertyListScreenState();
}

class _PropertyListScreenState extends State<PropertyListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OwnerPropertyViewModel>(context, listen: false).loadProperties();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Properties')),
      body: Consumer<OwnerPropertyViewModel>(builder: (context, vm, _) {
        if (vm.isLoading) return const Center(child: CircularProgressIndicator());
        if (vm.error != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${vm.error}', textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => vm.loadProperties(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }
        if (vm.properties.isEmpty) return const Center(child: Text('No properties yet'));
        return ListView.builder(
          itemCount: vm.properties.length,
          itemBuilder: (context, i) {
            final p = vm.properties[i];
            return ListTile(
              title: Text(p.name),
              subtitle: Text(p.address ?? ''),
              onTap: () async {
                final changed = await Navigator.push(context, MaterialPageRoute(builder: (_) => EditPropertyScreen(property: p, viewModel: vm)));
                if (changed == true) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Property updated')));
                }
              },
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await vm.removeProperty(p.id);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Property removed')));
                },
              ),
            );
          },
        );
      }),
      floatingActionButton: Builder(
        builder: (context) {
          final vm = Provider.of<OwnerPropertyViewModel>(context, listen: false);
          return FloatingActionButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => AddPropertyScreen(viewModel: vm)));
            },
            child: const Icon(Icons.add),
          );
        },
      ),
    );
  }
}
