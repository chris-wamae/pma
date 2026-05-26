import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'view/authentication/login.dart';
import 'view/authentication/register.dart';
import 'view/authentication/otp.dart';
import 'view/authentication/reset.dart';
import 'view/owner/property_list.dart';
import 'view/owner/add_property.dart';
import 'view/owner/owner_dashboard.dart';
import 'view/manager/manager_dashboard.dart';
import 'view/tenant/TenantDashboard.dart';
import 'view/general/general_dashboard.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (_) => AuthViewModel(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMA',
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple)),
      //home: const ManagerDashboard(),
      home: const LoginScreen(),
      //home: const GeneralDashboard(),
      routes: {
        '/login': (_) => const LoginScreen(),
        '/register': (_) => const RegisterScreen(),
        '/otp': (_) => const OtpScreen(),
        '/reset': (_) => const ResetPasswordScreen(),
              '/owner': (_) => const OwnerDashboard(),
              '/owner/properties': (_) => PropertyListScreen(),
              '/manager': (_) => const ManagerDashboard(),
              '/tenant': (_) => const TenantDashboard(),
              '/general': (_) => const GeneralDashboard(),
            },

    );
  }
}

