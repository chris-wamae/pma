import 'package:flutter/material.dart';
import '../../models/property_model.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import 'edit_property_manager.dart';

class EditPropertyScreen extends StatefulWidget {
  final PropertyModel property;
  final OwnerPropertyViewModel viewModel;

  const EditPropertyScreen({super.key, required this.property, required this.viewModel});

  @override
  State<EditPropertyScreen> createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _name;
  late TextEditingController _address;
  late TextEditingController _units;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController(text: widget.property.name);
    _address = TextEditingController(text: widget.property.address ?? '');
    _units = TextEditingController(text: widget.property.units.toString());
  }

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
      appBar: AppBar(title: const Text('Edit Property')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      if (!(_formKey.currentState?.validate() ?? false)) return;
                      final updated = PropertyModel(
                        id: widget.property.id,
                        ownerId: widget.property.ownerId,
                        name: _name.text.trim(),
                        address: _address.text.trim().isEmpty ? null : _address.text.trim(),
                        units: int.tryParse(_units.text) ?? widget.property.units,
                        createdAt: widget.property.createdAt,
                      );
                      final ok = await vm.updateProperty(updated);
                      if (ok) {
                        if (!mounted) return;
                        Navigator.pop(context, true);
                      } else {
                        if (!mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(vm.error ?? 'Failed to update property')));
                      }
                    },
                    child: const Text('Save'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditPropertyManagerScreen(
                            propertyId: widget.property.id,
                            viewModel: vm,
                          ),
                        ),
                      );
                    },
                    child: const Text('Managers'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
