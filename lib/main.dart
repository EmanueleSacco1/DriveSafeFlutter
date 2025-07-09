import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/firebase_options.dart'; // Importa le opzioni Firebase
import 'package:drivesafe/ui/auth/login_screen.dart'; // La tua schermata di login
import 'package:drivesafe/ui/main/main_screen.dart'; // Importa MainScreen
import 'package:drivesafe/viewmodels/auth_view_model.dart';
import 'package:drivesafe/viewmodels/car_detail_view_model.dart'; // Potrebbe essere necessario per i provider
import 'package:drivesafe/viewmodels/garage_view_model.dart';
import 'package:drivesafe/viewmodels/home_view_model.dart';
import 'package:drivesafe/viewmodels/performance_view_model.dart';
import 'package:drivesafe/viewmodels/profile_view_model.dart';
import 'package:drivesafe/viewmodels/route_detail_view_model.dart';
import 'package:drivesafe/viewmodels/routes_view_model.dart';
import 'package:drivesafe/data/local/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final AppDatabase database = AppDatabase();
  final CarDao carDao = CarDao(database);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => HomeViewModel()),
        ChangeNotifierProvider(create: (_) => PerformanceViewModel()),
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => RoutesViewModel()),
        ChangeNotifierProvider(create: (_) => GarageViewModel(carDao)),

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
      title: 'DriveSafe',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Consumer<AuthViewModel>(
        builder: (context, authViewModel, _) {
          if (authViewModel.currentUser != null) {
            return const MainScreen();
          } else {
            return const LoginScreen();
          }
        },
      ),
    );
  }
}
