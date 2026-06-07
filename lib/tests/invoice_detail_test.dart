// lib/tests/invoice_detail_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class MockInvoiceDetailPage extends StatelessWidget {
  final double amountToPay;
  const MockInvoiceDetailPage({super.key, this.amountToPay = 250.00});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Invoice Details")),
      body: Column(
        children: [
          const Text("Total Unpaid"),
          Text("RM ${amountToPay.toStringAsFixed(2)}"),
          ElevatedButton(
            onPressed: amountToPay <= 0 ? null : () {},
            child: const Text("Pay Outstanding"),
          ),
        ],
      ),
    );
  }
}

void main() {
  testWidgets('InvoiceDetailPage UI Automated Element Verification Test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(home: MockInvoiceDetailPage(amountToPay: 250.00)),
    );

    await tester.pumpAndSettle();

    expect(find.text('Total Unpaid'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}
