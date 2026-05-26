import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import '../../models/property_model.dart';
import 'edit_property.dart';
import 'add_property.dart';

class PropertyListScreen extends StatelessWidget {
  const PropertyListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OwnerPropertyViewModel()..loadProperties(),
      child: Scaffold(
        appBar: AppBar(title: const Text('Properties')),
        body: Consumer<OwnerPropertyViewModel>(builder: (context, vm, _) {
          if (vm.isLoading) return const Center(child: CircularProgressIndicator());
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
      ),
    );
  }
}
