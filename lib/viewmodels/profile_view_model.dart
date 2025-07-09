import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drivesafe/data/model/user.dart' as app_user; // Alias for your User model

/// ViewModel for the Profile screen.
/// Manages fetching, creating, and saving user profile data
/// from Firebase Firestore.
/// Equivalent to ProfileViewModel.kt.
class ProfileViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late final CollectionReference _usersCollection;

  // User profile data.
  app_user.User? _userProfile;
  app_user.User? get userProfile => _userProfile;

  // Loading state.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Error message.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Save success message.
  String? _saveSuccessMessage;
  String? get saveSuccessMessage => _saveSuccessMessage;

  ProfileViewModel() {
    // Initialize the Firestore collection.
    _usersCollection = _firestore.collection('users');
    // Listen for authentication state changes to load the profile.
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        fetchUserProfile(user.uid);
      } else {
        _userProfile = null;
        notifyListeners();
      }
    });
  }

  /// Fetches the user profile from Firestore.
  /// If the user does not exist, a basic profile is created.
  /// Equivalent to the fetch logic in ProfileViewModel.kt.
  Future<void> fetchUserProfile(String uid) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final docSnapshot = await _usersCollection.doc(uid).get();

      if (docSnapshot.exists) {
        _userProfile = app_user.User.fromJson(docSnapshot.data() as Map<String, dynamic>);
      } else {
        // If the document does not exist, create a basic user profile.
        final email = _auth.currentUser?.email ?? '';
        _userProfile = app_user.User(
          uid: uid,
          email: email,
          username: email.split('@')[0], // Default username from email
          registrationTimestamp: DateTime.now(),
        );
        await _usersCollection.doc(uid).set(_userProfile!.toJson());
      }
    } catch (e) {
      _errorMessage = 'Errore nel caricamento del profilo: ${e.toString()}';
      _userProfile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Saves (or updates) the user profile to Firestore.
  /// Equivalent to the saveUserProfile logic in ProfileViewModel.kt.
  Future<void> saveUserProfile(app_user.User user) async {
    _isLoading = true;
    _errorMessage = null;
    _saveSuccessMessage = null; // Reset the success message
    notifyListeners();

    try {
      await _usersCollection.doc(user.uid).set(user.toJson());
      _userProfile = user; // Update the local profile
      _saveSuccessMessage = 'Profilo salvato con successo!'; // Set the success message
    } catch (e) {
      _errorMessage = 'Errore nel salvataggio del profilo: ${e.toString()}';
      _saveSuccessMessage = null; // Ensure success message is null in case of error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Resets the save success message.
  void resetSaveSuccessMessage() {
    _saveSuccessMessage = null;
    notifyListeners();
  }

  /// Resets the error message.
  void resetErrorMessage() {
    _errorMessage = null;
    notifyListeners();
  }
}