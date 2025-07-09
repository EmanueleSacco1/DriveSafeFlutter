import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivesafe/data/model/route.dart' as app_route; // Alias for your Route model

/// ViewModel responsible for managing and providing data related to a specific route.
/// It fetches a single [Route] object from Firebase Firestore and exposes its state
/// (route data, loading state, error messages) via [LiveData] (here ChangeNotifier).
/// Equivalent to RouteDetailViewModel.kt.
class RouteDetailViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Private [MutableLiveData] that holds the fetched [Route] object.
  // Can be null if no route is found or an error occurs.
  app_route.Route? _route;
  app_route.Route? get route => _route;

  // Private [MutableLiveData] that indicates the loading state of the data retrieval operation.
  // True when data is being fetched, false otherwise.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Private [MutableLiveData] for error messages.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  /// Fetches a specific route from Firestore given its ID.
  /// Equivalent to fetchRoute(routeId: String) in RouteDetailViewModel.kt.
  Future<void> fetchRoute(String routeId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final docSnapshot = await _firestore.collection('routes').doc(routeId).get();

      if (docSnapshot.exists) {
        // Map document data to a Route object.
        // Assign the document ID to the 'id' field of the Route model.
        _route = app_route.Route.fromJson(docSnapshot.data() as Map<String, dynamic>)..id = docSnapshot.id;
      } else {
        _route = null;
        _errorMessage = 'Percorso non trovato.';
      }
    } catch (e) {
      _errorMessage = 'Errore nel caricamento del percorso: ${e.toString()}';
      debugPrint('Error fetching route: $e');
      _route = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets the error message.
  void resetErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}