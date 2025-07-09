import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/routes_view_model.dart';
import 'package:drivesafe/data/model/route.dart' as app_route; // Alias for your Route model
import 'package:drivesafe/ui/routes/route_list_adapter.dart'; // Import the adapter and interface

/// A [Fragment] screen responsible for displaying a list of recorded driving routes.
/// It fetches route data and associated user information from Firebase Firestore
/// and displays them in a [RecyclerView] (here, ListView). It also handles navigation
/// to [RouteDetailScreen] when a route item is clicked.
class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> implements OnItemClickListener { // Corrected: OnItemClickListener

  @override
  void initState() {
    super.initState();
    // Fetch routes when the screen is initialized.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RoutesViewModel>(context, listen: false).fetchRoutes();
    });
  }

  /// Displays a Snackbar message.
  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routesViewModel = Provider.of<RoutesViewModel>(context);

    // Listen for error messages from the ViewModel.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (routesViewModel.errorMessage != null) {
        _showSnackBar(routesViewModel.errorMessage!, isError: true);
        routesViewModel.resetErrorMessage();
      }
    });

    if (routesViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (routesViewModel.routes.isEmpty) {
      return const Center(
        child: Text(
          'Nessun percorso registrato.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      );
    }

    return RouteListAdapter(
      routes: routesViewModel.routes,
      usersMap: routesViewModel.usersMap,
      onItemClick: this,
    );
  }

  @override
  void onItemClick(app_route.Route route) {

  }
}