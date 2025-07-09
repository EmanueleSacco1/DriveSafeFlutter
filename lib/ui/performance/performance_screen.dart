import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/performance_view_model.dart';

/// Screen for displaying real-time driving performance data.
class PerformanceScreen extends StatefulWidget {
  const PerformanceScreen({super.key});

  @override
  State<PerformanceScreen> createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  // StreamSubscription<Position>? _positionStreamSubscription; // To manage listening to position
  bool _isLocationServiceEnabled = false; // Location service status
  LocationPermission? _permissionStatus; // Location permission status

  @override
  void initState() {
    super.initState();
    _checkLocationServiceAndPermission();
  }

  @override
  void dispose() {
    // _positionStreamSubscription?.cancel(); // Cancel location listening
    // Reset ViewModel data when the screen is disposed
    Provider.of<PerformanceViewModel>(context, listen: false).resetData();
    super.dispose();
  }

  /// Checks the status of location services and permissions.
  Future<void> _checkLocationServiceAndPermission() async {
    _isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
    _permissionStatus = await Geolocator.checkPermission();

    if (!mounted) return;

    if (!_isLocationServiceEnabled) {
      _showSnackBar('Servizio di localizzazione disabilitato. Abilitalo per il monitoraggio delle prestazioni.', isError: true);
    } else if (_permissionStatus == LocationPermission.denied) {
      _showSnackBar('Permesso di localizzazione negato. Richiesta permesso...', isError: true);
      _requestLocationPermission();
    } else if (_permissionStatus == LocationPermission.deniedForever) {
      _showSnackBar('Permesso di localizzazione permanentemente negato. Abilitalo dalle impostazioni.', isError: true);
    } else {
      _startListeningToLocationUpdates();
    }
    setState(() {}); // Update the UI with permission/service status
  }

  /// Requests location permissions.
  Future<void> _requestLocationPermission() async {
    final status = await Permission.locationWhenInUse.request(); // Request "while in use" permission
    if (!mounted) return;

    setState(() {
      _permissionStatus = _mapPermissionStatus(status);
    });

    if (_permissionStatus == LocationPermission.whileInUse || _permissionStatus == LocationPermission.always) {
      _startListeningToLocationUpdates();
    } else {
      _showSnackBar('Permesso di localizzazione non concesso.', isError: true);
    }
  }

  /// Maps the permission status from `permission_handler` to `geolocator`.
  LocationPermission _mapPermissionStatus(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return LocationPermission.whileInUse;
      case PermissionStatus.denied:
        return LocationPermission.denied;
      case PermissionStatus.permanentlyDenied:
        return LocationPermission.deniedForever;
      default:
        return LocationPermission.denied;
    }
  }

  /// Starts listening to location updates.
  void _startListeningToLocationUpdates() {
    // Cancel any previous subscriptions to avoid duplicates
    // _positionStreamSubscription?.cancel();

    // Subscribe to location updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Get updates for every position change
        timeLimit: null,
      ),
    ).listen((Position position) {
      if (!mounted) return; // Avoid setState on unmounted widgets
      // Pass the position to the ViewModel for performance data processing
      Provider.of<PerformanceViewModel>(context, listen: false).updatePerformanceData(position);
    }).onError((error) {
      debugPrint('Error in position stream: $error');
      _showSnackBar('Errore nel servizio di localizzazione: ${error.toString()}', isError: true);
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
    final performanceViewModel = Provider.of<PerformanceViewModel>(context);

    // Listen for notification messages from the ViewModel
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (performanceViewModel.notificationMessage != null) {
        _showSnackBar(performanceViewModel.notificationMessage!);
        performanceViewModel.resetNotificationMessage();
      }
    });

    // Check if permissions have been granted
    final bool hasPermission = _permissionStatus == LocationPermission.whileInUse ||
        _permissionStatus == LocationPermission.always;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Text(
                    'Velocità Corrente',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  Text(
                    '${performanceViewModel.speed.toStringAsFixed(0)} km/h',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: performanceViewModel.speed > 50 ? Colors.red : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard(
                  context,
                  'Velocità Media',
                  '${performanceViewModel.averageSpeed.toStringAsFixed(0)} km/h',
                  Icons.speed,
                  Colors.blue,
                ),
                _buildMetricCard(
                  context,
                  'Velocità Massima',
                  '${performanceViewModel.maxSpeed.toStringAsFixed(0)} km/h',
                  Icons.speed_outlined,
                  Colors.orange,
                ),
                _buildMetricCard(
                  context,
                  'Accelerazioni \n Brusche',
                  '${performanceViewModel.accelerationCount}',
                  Icons.arrow_upward,
                  Colors.purple,
                ),
                _buildMetricCard(
                  context,
                  'Frenate \n Brusche',
                  '${performanceViewModel.brakingCount}',
                  Icons.arrow_downward,
                  Colors.deepPurple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: hasPermission ? performanceViewModel.resetData : null,
            icon: const Icon(Icons.refresh),
            label: const Text('Reset Dati Performance'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[700],
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 5,
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
          if (!hasPermission)
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Text(
                'Per visualizzare le performance, abilita i permessi di localizzazione.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Theme.of(context).colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }

  /// Helper to build metric cards.
  Widget _buildMetricCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}