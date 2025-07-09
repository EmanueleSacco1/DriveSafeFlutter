import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivesafe/data/model/route.dart' as app_route; // Alias for your Route model
import 'package:drivesafe/data/model/user.dart' as app_user; // Alias for your User model

/// ViewModel responsible for managing and providing a list of driving routes.
/// It retrieves [Route] objects from Firebase Firestore and exposes their state
/// (list of routes, loading state, error messages) via [LiveData] (here ChangeNotifier/Stream).
class RoutesViewModel extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Private list of [MutableLiveData] that contains the retrieved [Route] objects.
  List<app_route.Route> _routes = [];
  List<app_route.Route> get routes => _routes;

  // Private map of user IDs to usernames for displaying the route author.
  Map<String, String> _usersMap = {};
  Map<String, String> get usersMap => _usersMap;

  // Private [MutableLiveData] that indicates the loading state of the data retrieval operation.
  // True when data is being fetched, false otherwise.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Private [MutableLiveData] for error messages.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  RoutesViewModel() {
    // Starts fetching routes upon ViewModel initialization.
    fetchRoutes();
  }

  /// Fetches driving routes and their associated user data from Firestore.
  Future<void> fetchRoutes() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Retrieve all documents from the "routes" collection, ordered by timestamp in descending order.
      final querySnapshot = await _firestore
          .collection('routes')
          .orderBy('timestamp', descending: true)
          .get();

      // Map each document to a Route object, filtering out any null results.
      _routes = querySnapshot.docs.map((doc) {
        final data = doc.data();
        // Assign the document ID to the 'id' field of the Route model
        return app_route.Route.fromJson(data)..id = doc.id;
      }).toList();

      // Fetch usernames for all userIds present in the routes.
      await _fetchUsernamesForRoutes();
    } catch (e) {
      _errorMessage = 'Errore durante il caricamento dei percorsi: ${e.toString()}';
      debugPrint('Error fetching routes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetches usernames for the userIds present in the routes.
  Future<void> _fetchUsernamesForRoutes() async {
    final Set<String> userIds = _routes.map((route) => route.userId).toSet();
    final Map<String, String> fetchedUsers = {};

    if (userIds.isEmpty) {
      _usersMap = {};
      return;
    }

    // Firestore has a limit of 10 for 'in' queries. If there are more than 10 IDs,
    // we should make multiple queries. For simplicity, we assume less than 10 IDs.
    // In a real app, you would handle this with query batches.
    if (userIds.length > 10) {
      debugPrint('Warning: More than 10 user IDs for username fetching. Consider batching queries.');
      // Implement batch query logic if necessary
    }

    try {
      final usersSnapshot = await _firestore
          .collection('users')
          .where(FieldPath.documentId, whereIn: userIds.toList())
          .get();

      for (var doc in usersSnapshot.docs) {
        final user = app_user.User.fromJson(doc.data());
        fetchedUsers[user.uid] = user.username;
      }
      _usersMap = fetchedUsers;
    } catch (e) {
      debugPrint('Error fetching usernames: $e');
      // Do not set global errorMessage, as routes might still be displayed.
    }
  }

  /// Resets the error message.
  void resetErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}