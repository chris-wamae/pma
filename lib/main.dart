import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/file_viewmodel.dart';
import 'viewmodels/owner_property_viewmodel.dart';
import 'repositories/file_repository.dart';
import 'repositories/firebase_property_repository.dart';
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


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(
          create: (_) => FileViewModel(fileRepository: FileRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => OwnerPropertyViewModel(FirebasePropertyRepository()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMA',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const LoginScreen(),
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
