import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Per salvare i dati utente
import 'package:drivesafe/data/model/user.dart' as app_user; // Alias per evitare conflitti con firebase_auth.User

/// ViewModel per la gestione dell'autenticazione utente con Firebase.
/// Estende ChangeNotifier per notificare i listener (UI) sui cambiamenti di stato.
class AuthViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stato corrente dell'utente autenticato.
  User? _currentUser;
  User? get currentUser => _currentUser;

  // Stato di caricamento per le operazioni di autenticazione.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Messaggio di errore per la UI.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Messaggio di successo per la UI.
  String? _successMessage;
  String? get successMessage => _successMessage;

  AuthViewModel() {
    // Ascolta i cambiamenti dello stato di autenticazione Firebase.
    // Questo è l'equivalente di onAuthStateChanged in Kotlin.
    _auth.authStateChanges().listen((User? user) {
      _currentUser = user;
      notifyListeners(); // Notifica la UI che lo stato dell'utente è cambiato.
    });
  }

  /// Resetta i messaggi di errore e successo.
  void resetMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  /// Tenta di registrare un nuovo utente con email e password.
  /// Equivalente alla logica in RegisterActivity.kt.
  Future<void> registerUser(String email, String password) async { // Rinominato da signUp
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Se la registrazione ha successo, crea un documento utente in Firestore.
      if (userCredential.user != null) {
        final newUser = app_user.User(
          uid: userCredential.user!.uid,
          email: email,
          username: email, // Username iniziale come email, può essere modificato
          registrationTimestamp: DateTime.now(),
        );
        await _firestore.collection('users').doc(newUser.uid).set(newUser.toJson());

        _successMessage = 'Registrazione avvenuta con successo!';
      }
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      _errorMessage = 'Si è verificato un errore inatteso durante la registrazione: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tenta di effettuare il login di un utente con email e password.
  /// Equivalente alla logica in LoginActivity.kt.
  Future<void> signInUser(String email, String password) async { // Rinominato da signIn
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _successMessage = 'Accesso effettuato con successo!';
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      _errorMessage = 'Si è verificato un errore inatteso durante il login: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Tenta di inviare un'email di reset password.
  /// Equivalente alla logica in ResetPasswordActivity.kt.
  Future<void> sendPasswordResetEmail(String email) async { // Rinominato da resetPassword
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _auth.sendPasswordResetEmail(email: email);
      _successMessage = 'Email per il reset della password inviata.';
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      _errorMessage = 'Si è verificato un errore inatteso: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Effettua il logout dell'utente corrente.
  /// Equivalente alla logica in LogoutFragment.kt.
  Future<void> signOut() async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      await _auth.signOut();
      _successMessage = 'Logout effettuato con successo.';
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getFirebaseAuthErrorMessage(e.code);
    } catch (e) {
      _errorMessage = 'Si è verificato un errore durante il logout: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mappa i codici di errore di Firebase Auth a messaggi più leggibili.
  String _getFirebaseAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'email-already-in-use':
        return 'Questa email è già in uso. Prova ad accedere o a usare un\'altra email.';
      case 'invalid-email':
        return 'L\'indirizzo email non è valido.';
      case 'weak-password':
        return 'La password è troppo debole. Deve contenere almeno 6 caratteri.';
      case 'user-not-found':
        return 'Nessun utente trovato con questa email.';
      case 'wrong-password':
        return 'Password errata. Riprova.';
      case 'network-request-failed':
        return 'Errore di connessione. Controlla la tua connessione internet.';
      case 'too-many-requests':
        return 'Troppi tentativi di accesso falliti. Riprova più tardi.';
      default:
        return 'Errore di autenticazione: $errorCode';
    }
  }
}
