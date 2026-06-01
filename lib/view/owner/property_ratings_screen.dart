import 'package:flutter/material.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import '../../models/property_rating_model.dart';

class PropertyRatingsScreen extends StatefulWidget {
  final String propertyId;
  final OwnerPropertyViewModel viewModel;

  const PropertyRatingsScreen({
    super.key,
    required this.propertyId,
    required this.viewModel,
  });

  @override
  State<PropertyRatingsScreen> createState() => _PropertyRatingsScreenState();
}

class _PropertyRatingsScreenState extends State<PropertyRatingsScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadRatingsForProperty(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Property Ratings')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, child) {
          if (vm.isRatingsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.ratingsError != null) {
            return Center(
              child: Text('Error loading ratings: ${vm.ratingsError}'),
            );
          }

          if (vm.propertyRatings.isEmpty) {
            return const Center(
              child: Text('No ratings found for this property.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.propertyRatings.length,
            itemBuilder: (context, index) {
              final rate = vm.propertyRatings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Row(
                    children: [
                      const SizedBox(width: 8),
                      Text(
                        rate.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(rate.comment),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(), // Keep space for alignment if needed
                          Text(
                            rate.date,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
