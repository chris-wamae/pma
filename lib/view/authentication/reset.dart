import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _tokenCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Password Reset')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
          ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                final ok = await vm.sendPasswordReset(_emailCtrl.text.trim());
                if (!mounted) return;
                messenger.showSnackBar(SnackBar(content: Text(ok ? 'Reset sent (mock)' : 'No such user')));
              },
              child: const Text('Send reset email')),
          const Divider(),
          TextField(controller: _tokenCtrl, decoration: const InputDecoration(labelText: 'Reset token')),
          TextField(controller: _pwdCtrl, decoration: const InputDecoration(labelText: 'New password'), obscureText: true),
          ElevatedButton(
              onPressed: () async {
                final ok = await vm.resetPassword(_emailCtrl.text.trim(), _tokenCtrl.text.trim(), _pwdCtrl.text);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Password reset' : 'Invalid token')));
              },
              child: const Text('Reset password')),
        ]),
      ),
    );
  }
}
