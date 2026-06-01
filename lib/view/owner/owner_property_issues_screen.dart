import 'package:flutter/material.dart';
import '../../viewmodels/owner_property_viewmodel.dart';
import '../../models/property_issue_model.dart';

class OwnerPropertyIssuesScreen extends StatefulWidget {
  final String propertyId;
  final OwnerPropertyViewModel viewModel;

  const OwnerPropertyIssuesScreen({
    super.key,
    required this.propertyId,
    required this.viewModel,
  });

  @override
  State<OwnerPropertyIssuesScreen> createState() =>
      _OwnerPropertyIssuesScreenState();
}

class _OwnerPropertyIssuesScreenState extends State<OwnerPropertyIssuesScreen> {
  @override
  void initState() {
    super.initState();
    widget.viewModel.loadPropertyIssues(widget.propertyId);
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    return Scaffold(
      appBar: AppBar(title: const Text('Property Issues')),
      body: ListenableBuilder(
        listenable: vm,
        builder: (context, child) {
          if (vm.isIssuesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (vm.issuesError != null) {
            return Center(
              child: Text('Error loading issues: ${vm.issuesError}'),
            );
          }

          if (vm.propertyIssues.isEmpty) {
            return const Center(
              child: Text('No escalated issues found for this property.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: vm.propertyIssues.length,
            itemBuilder: (context, index) {
              final issue = vm.propertyIssues[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            issue.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          _buildStatusChip(issue.status),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(issue.description),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Cost: RM${issue.cost.toStringAsFixed(2)}'),
                          Text('Date: ${issue.date}'),
                        ],
                      ),
                      if (issue.status == 'pending') ...[
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                final ok = await vm.updateIssueStatus(
                                  issue.id,
                                  'rejected',
                                );
                                if (ok) {
                                  // Reload issues to update UI
                                  await vm.loadPropertyIssues(
                                    widget.propertyId,
                                  );
                                }
                              },
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                final ok = await vm.updateIssueStatus(
                                  issue.id,
                                  'approved',
                                );
                                if (ok) {
                                  // Reload issues to update UI
                                  await vm.loadPropertyIssues(
                                    widget.propertyId,
                                  );
                                }
                              },
                              child: const Text('Approve'),
                            ),
                          ],
                        ),
                      ],
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

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'approved':
        color = Colors.green;
        break;
      case 'rejected':
        color = Colors.red;
        break;
      default:
        color = Colors.orange;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
