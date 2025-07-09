import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart'; // For Position type

/// ViewModel for the Performance screen.
/// Manages and calculates driving performance data such as current speed,
/// average speed, maximum speed, and counts of sudden braking/acceleration.
class PerformanceViewModel extends ChangeNotifier {
  // Current vehicle speed in kilometers per hour (km/h).
  double _speed = 0.0;
  double get speed => _speed;

  // Calculated average speed in kilometers per hour (km/h).
  double _averageSpeed = 0.0;
  double get averageSpeed => _averageSpeed;

  // Cumulative count of sudden acceleration events.
  int _accelerationCount = 0;
  int get accelerationCount => _accelerationCount;

  // Cumulative count of sudden braking events.
  int _brakingCount = 0;
  int get brakingCount => _brakingCount;

  // Maximum speed reached in kilometers per hour (km/h).
  double _maxSpeed = 0.0;
  double get maxSpeed => _maxSpeed;

  // Generic notification message for the UI.
  String? _notificationMessage;
  String? get notificationMessage => _notificationMessage;

  // Internal variables for calculations
  final List<double> _speedSamples = []; // Speed samples in m/s
  double _lastSpeed = 0.0; // Last recorded speed in m/s

  // Constants for acceleration/braking detection (can be calibrated)
  static const double _accelerationThreshold = 2.0; // m/s^2 (approx. 7.2 km/h/s)
  static const double _brakingThreshold = -2.5; // m/s^2 (approx. -9 km/h/s)

  DateTime? _lastPositionTimestamp;

  /// Updates performance data with a new position.
  void updatePerformanceData(Position position) {
    if (!hasListeners) return; // Do not update if there are no listeners

    final currentSpeedMps = position.speed; // Speed in meters per second

    // Update current speed (converted to km/h)
    _speed = (currentSpeedMps * 3.6).roundToDouble();

    // Update maximum speed (converted to km/h)
    if (_speed > _maxSpeed) {
      _maxSpeed = _speed;
    }

    // Add speed sample for average calculation
    _speedSamples.add(currentSpeedMps);
    _calculateAverageSpeed();

    if (_lastSpeed != 0.0 && position.timestamp != null && position.timestamp != _lastPositionTimestamp) {
      final double timeDeltaSeconds = (position.timestamp!.millisecondsSinceEpoch - (_lastPositionTimestamp?.millisecondsSinceEpoch ?? 0)) / 1000.0;
      if (timeDeltaSeconds > 0) {
        final double acceleration = (currentSpeedMps - _lastSpeed) / timeDeltaSeconds;

        if (acceleration > _accelerationThreshold) {
          _accelerationCount++;
          notifyEvent('Accelerazione improvvisa rilevata!');
        } else if (acceleration < _brakingThreshold) {
          _brakingCount++;
          notifyEvent('Frenata improvvisa rilevata!');
        }
      }
    }
    _lastSpeed = currentSpeedMps;
    _lastPositionTimestamp = position.timestamp;

    notifyListeners();
  }

  /// Calculates and updates the average speed based on collected samples.
  void _calculateAverageSpeed() {
    if (_speedSamples.isNotEmpty) {
      final totalSpeedMps = _speedSamples.reduce((a, b) => a + b);
      _averageSpeed = (totalSpeedMps / _speedSamples.length * 3.6).roundToDouble();
    } else {
      _averageSpeed = 0.0;
    }
  }

  /// Sets a notification message for the UI.
  void notifyEvent(String message) {
    _notificationMessage = message;
    notifyListeners();
  }

  /// Resets the notification message after it has been shown.
  void resetNotificationMessage() {
    _notificationMessage = null;
    notifyListeners();
  }

  /// Resets all performance data to initial values.
  void resetData() {
    _speedSamples.clear();
    _speed = 0.0;
    _averageSpeed = 0.0;
    _accelerationCount = 0;
    _brakingCount = 0;
    _maxSpeed = 0.0;
    _lastSpeed = 0.0;
    _notificationMessage = null;
    _lastPositionTimestamp = null;
    notifyListeners();
  }

  @override
  void dispose() {
    resetData(); // Resets data when the ViewModel is disposed
    super.dispose();
  }
}