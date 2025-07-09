import 'package:flutter/material.dart';
import 'package:drivesafe/ui/home/home_screen.dart'; // Import HomeScreen
import 'package:drivesafe/ui/garage/garage_screen.dart';
// import 'package:drivesafe/ui/routes/routes_screen.dart'; // Removed: Routes Screen
import 'package:drivesafe/ui/social/routes_screen.dart';
import 'package:drivesafe/ui/performance/performance_screen.dart';
import 'package:drivesafe/ui/profile/profile_screen.dart';
import 'package:drivesafe/ui/auth/login_screen.dart'; // For logout
import 'package:firebase_auth/firebase_auth.dart'; // To listen to authentication state

/// The main screen of the DriveSafe application after login.
/// This screen sets up the tabbed navigation (BottomNavigationBar)
/// and manages user session control.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; // Index of the selected screen

  // List of screens to display in the BottomNavigationBar
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    GarageScreen(),
    RoutesScreen(),
    PerformanceScreen(),
    ProfileScreen(),
  ];

  /// Handles the tap event on a [BottomNavigationBarItem].
  /// Updates the [_selectedIndex] to reflect the newly selected screen.
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Listen for authentication state changes.
    // If the user logs out, navigate back to the LoginScreen.
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // If the user is not logged in, navigate to the login screen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
              (Route<dynamic> route) => false, // Removes all previous routes
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DriveSafe'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Sign out the current user from Firebase.
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_car),
            label: 'Garage',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Social',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.speed),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}