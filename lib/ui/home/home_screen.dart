import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/home_view_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Cloud Firestore directly
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:drivesafe/data/model/route.dart' as app_route; // Alias for your Route model

/// Home screen displaying the map, current speed, and speed limit.
/// Allows recording a route.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MapController _mapController = MapController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance; // Initialize FirebaseAuth

  bool _isRecording = false;
  List<LatLng> _currentPathPoints = [];
  DateTime? _startTime;
  double _totalDistance = 0.0;
  LatLng? _lastPosition;
  double _maxSpeed = 0.0;
  double _averageSpeed = 0.0; // Will be calculated at the end

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  /// Checks and requests location permissions.
  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showSnackBar('Permesso di localizzazione negato.', isError: true);
        return;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      _showSnackBar('Permesso di localizzazione permanentemente negato. Abilitalo dalle impostazioni.', isError: true);
      return;
    }
    _startLocationUpdates();
  }

  /// Starts listening for continuous location updates.
  void _startLocationUpdates() {
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
        distanceFilter: 0, // Continuous updates
      ),
    ).listen((Position position) {
      if (!mounted) return;
      final homeViewModel = Provider.of<HomeViewModel>(context, listen: false);
      homeViewModel.updateSpeed(position.speed);

      if (_isRecording) {
        final currentLatLng = LatLng(position.latitude, position.longitude);
        setState(() {
          _currentPathPoints.add(currentLatLng);
          if (_lastPosition != null) {
            _totalDistance += Geolocator.distanceBetween(
              _lastPosition!.latitude,
              _lastPosition!.longitude,
              currentLatLng.latitude,
              currentLatLng.longitude,
            );
          }
          _lastPosition = currentLatLng;

          final currentSpeedKmh = position.speed * 3.6;
          if (currentSpeedKmh > _maxSpeed) {
            _maxSpeed = currentSpeedKmh;
          }
        });
        _mapController.move(currentLatLng, _mapController.camera.zoom);
      } else {
        _mapController.move(LatLng(position.latitude, position.longitude), _mapController.camera.zoom);
      }
    }).onError((error) {
      _showSnackBar('Errore nel servizio di localizzazione: ${error.toString()}', isError: true);
    });
  }

  /// Toggles the recording state of a route.
  /// If recording, stops and saves the route. If not, starts recording.
  void _toggleRecording() async {
    if (_isRecording) {
      // Stop recording
      setState(() {
        _isRecording = false;
      });
      if (_startTime != null && _currentPathPoints.isNotEmpty) {
        final endTime = DateTime.now();
        final durationSeconds = endTime.difference(_startTime!).inSeconds;
        _averageSpeed = durationSeconds > 0 ? (_totalDistance / durationSeconds) * 3.6 : 0.0; // m/s to km/h

        await _saveRoute(
          _currentPathPoints,
          _startTime!.millisecondsSinceEpoch,
          endTime.millisecondsSinceEpoch,
          _totalDistance,
          _averageSpeed,
          _maxSpeed,
        );
      }
      _resetRecordingState();
      _showSnackBar('Registrazione percorso terminata e salvata!');
    } else {
      // Start recording
      _resetRecordingState(); // Ensure a clean state
      setState(() {
        _isRecording = true;
        _startTime = DateTime.now();
      });
      _showSnackBar('Registrazione percorso avviata!');
    }
  }

  /// Resets the recording state variables.
  void _resetRecordingState() {
    setState(() {
      _currentPathPoints = [];
      _startTime = null;
      _totalDistance = 0.0;
      _lastPosition = null;
      _maxSpeed = 0.0;
      _averageSpeed = 0.0;
    });
  }

  /// Saves the recorded route to Firestore.
  Future<void> _saveRoute(
      List<LatLng> path,
      int startTime,
      int endTime,
      double totalDistance,
      double averageSpeed,
      double maxSpeed,
      ) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      _showSnackBar('Errore: Utente non autenticato. Impossibile salvare il percorso.', isError: true);
      return;
    }

    final routeId = _firestore.collection('routes').doc().id; // Generate a new document ID
    final routeData = app_route.Route(
      id: routeId,
      userId: currentUser.uid,
      timestamp: DateTime.now().millisecondsSinceEpoch, // Convert DateTime to int
      pathPoints: path.map((latlng) => GeoPoint(latlng.latitude, latlng.longitude)).toList(), // Use GeoPoint directly
      startTime: startTime,
      endTime: endTime,
      totalDistance: totalDistance, // Already in meters
      averageSpeed: averageSpeed / 3.6, // Convert to m/s for the model
      maxSpeed: maxSpeed / 3.6, // Convert to m/s for the model
    );

    try {
      await _firestore.collection('routes').doc(routeId).set(routeData.toJson());
      debugPrint('Route successfully saved with ID: $routeId');
    } catch (e) {
      _showSnackBar('Errore nel salvataggio del percorso: ${e.toString()}', isError: true);
      debugPrint('Error saving route: $e');
    }
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
    final homeViewModel = Provider.of<HomeViewModel>(context);
    final currentSpeed = homeViewModel.speedKmh;
    final speedLimit = homeViewModel.speedLimit;

    return Scaffold(
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: LatLng(41.9028, 12.4964), // Rome, Italy
              initialZoom: 13.0,
              maxZoom: 18.0,
              minZoom: 3.0,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: 'com.example.drivesafe',
              ),
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: _currentPathPoints,
                    color: Colors.blue,
                    strokeWidth: 5.0,
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 16.0,
            left: 16.0,
            right: 16.0,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text(
                          'Velocità', // 'Speed'
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '$currentSpeed km/h',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: currentSpeed > speedLimit ? Colors.red : Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: FloatingActionButton.extended(
                onPressed: _toggleRecording,
                label: Text(_isRecording ? 'Ferma Registrazione' : 'Avvia Registrazione'),
                backgroundColor: _isRecording ? Colors.red : Theme.of(context).colorScheme.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}