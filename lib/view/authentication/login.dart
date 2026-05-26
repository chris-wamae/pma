import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/auth_viewmodel.dart';
import '../owner/property_list.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController();
  final _pwdCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<AuthViewModel>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _emailCtrl, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _pwdCtrl, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: vm.isLoading
                  ? null
                  : () async {
                      final navigator = Navigator.of(context);
                      final messenger = ScaffoldMessenger.of(context);
                      final ok = await vm.signIn(_emailCtrl.text.trim(), _pwdCtrl.text);
                      if (!mounted) return;
                      if (ok) {
                        final role = await vm.getUserRole();
                        final r = (role ?? 'owner').toLowerCase();
                        if (r.startsWith('owner')) {
                          navigator.pushReplacementNamed('/owner');
                        } else if (r.startsWith('manager')) {
                          navigator.pushReplacementNamed('/manager');
                        } else {
                          navigator.pushReplacementNamed('/tenant');
                        }
                      } else {
                        messenger.showSnackBar(SnackBar(content: Text(vm.error ?? 'Sign-in failed')));
                      }
                    },
              child: vm.isLoading ? const CircularProgressIndicator() : const Text('Sign In')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/register'), child: const Text('Create account')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/otp'), child: const Text('OTP verification')),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/reset'), child: const Text('Forgot password')),
          ],
        ),
      ),
    );
  }
}
