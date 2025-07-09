import 'package:flutter/material.dart';

/// ViewModel for the Home screen (Map).
/// Holds and manages data related to current speed, speed limit, and notification messages.
/// It does not have constructor dependencies, so it does not require a custom Factory
/// when used with `by viewModels()` or `ViewModelProvider(this)`.
class HomeViewModel extends ChangeNotifier {
  // Private variable for the current speed in kilometers per hour (Int).
  // Initialized to 0.
  int _speedKmh = 0;

  // Public getter ([speedKmh]) exposed to the UI (Screen).
  // The UI can observe this ViewModel to receive speed updates.
  int get speedKmh => _speedKmh;

  // Private variable for the speed limit in kilometers per hour (Int).
  // Currently, the limit is set to a fixed value (50).
  int _speedLimit = 50;

  // Public getter ([speedLimit]) exposed to the UI.
  int get speedLimit => _speedLimit;

  // Private variable for generic text messages to display to the user (e.g., via SnackBar).
  String? _notificationMessage;

  // Public getter ([notificationMessage]) exposed to the UI.
  String? get notificationMessage => _notificationMessage;

  /// Updates the speed value in the [_speedKmh] variable.
  /// @param metersPerSecond The speed received from the LocationManager, expressed in meters per second (Float).
  void updateSpeed(double metersPerSecond) {
    // Convert speed from meters per second to kilometers per hour (multiplying by 3.6).
    // Round the result to the nearest integer for cleaner display.
    final kmh = (metersPerSecond * 3.6).toInt();
    if (_speedKmh != kmh) {
      _speedKmh = kmh;
      notifyListeners(); // Notifica gli osservatori solo se il valore è cambiato
    }
  }

  /// Sets a message in the [_notificationMessage] variable to notify the UI.
  /// @param message The string message to display.
  void notifyEvent(String message) {
    _notificationMessage = message;
    notifyListeners();
  }

  /// Resets the notification message after it has been displayed.
  void resetNotificationMessage() {
    _notificationMessage = null;
    notifyListeners();
  }
}
