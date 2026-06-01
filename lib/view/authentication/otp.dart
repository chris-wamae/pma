import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _emailCtrl = TextEditingController();
  final _codeCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          Row(children: [
            Expanded(child: TextField(controller: _codeCtrl, decoration: const InputDecoration(labelText: 'Code'))),
            ElevatedButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await vm.sendOtp(_emailCtrl.text.trim());
                  if (!mounted) return;
                  messenger.showSnackBar(const SnackBar(content: Text('OTP sent (mock)')));
                },
                child: const Text('Send'))
          ]),
          const SizedBox(height: 12),
          ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final ok = await vm.verifyOtp(_emailCtrl.text.trim(), _codeCtrl.text.trim());
                if (!mounted) return;
                messenger.showSnackBar(SnackBar(content: Text(ok ? 'Verified' : 'Invalid code')));
              },
              child: const Text('Verify'))
        ]),
      ),
    );
  }
}
