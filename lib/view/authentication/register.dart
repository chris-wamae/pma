import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _nameCtrl, decoration: const InputDecoration(labelText: 'Full name')),
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _pwdCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await vm.signUp(_emailCtrl.text.trim(), _pwdCtrl.text, name: _nameCtrl.text.trim());
                      if (!mounted) return;
                      if (ok) {
                        Navigator.pop(context);
                        messenger.showSnackBar(const SnackBar(content: Text('Registration successful')));
                      } else {
                        messenger.showSnackBar(SnackBar(content: Text(vm.error ?? 'Registration failed')));
                      }
                    },
              child: vm.isLoading ? const CircularProgressIndicator() : const Text('Create Account')),
          ],
        ),
      ),
    );
  }
}
