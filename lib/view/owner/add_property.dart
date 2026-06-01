import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import '../../models/property_model.dart';

class AddPropertyScreen extends StatefulWidget {
  final OwnerPropertyViewModel viewModel;
  const AddPropertyScreen({super.key, required this.viewModel});

  @override
  State<AddPropertyScreen> createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _address = TextEditingController();
  final _units = TextEditingController(text: '1');

  @override
  void dispose() {
    _name.dispose();
    _address.dispose();
    _units.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;
    return Scaffold(
      appBar: AppBar(title: const Text('Add Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Property name'),
              validator: (v) => v == null || v.trim().isEmpty ? 'Property name is required' : null,
            ),
            TextFormField(controller: _address, decoration: const InputDecoration(labelText: 'Address')),
            TextFormField(
              controller: _units,
              decoration: const InputDecoration(labelText: 'Units'),
              keyboardType: TextInputType.number,
              validator: (v) {
                final n = int.tryParse(v ?? '');
                if (n == null || n < 1) return 'Enter a valid number of units';
                return null;
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                if (!(_formKey.currentState?.validate() ?? false)) return;
                final id = Uuid().v4();
                final p = PropertyModel(
                  id: id,
                  ownerId: '', // Handled by ViewModel
                  name: _name.text.trim(),
                  address: _address.text.trim().isEmpty ? null : _address.text.trim(),
                  units: int.tryParse(_units.text) ?? 1,
                );
                final ok = await vm.addProperty(p);
                if (ok) {
                  if (!mounted) return;
                  Navigator.pop(context);
                } else {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Failed to add property')));
                }
              },
              child: const Text('Save')),
          ]),
        ),
      ),
    );
  }
}
