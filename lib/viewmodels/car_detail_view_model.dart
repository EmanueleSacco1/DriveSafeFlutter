import 'package:flutter/material.dart';
import 'package:drivesafe/data/local/app_database.dart'; // Importa il database Drift
import 'package:drivesafe/data/model/expiration_status.dart'; // Importa l'enum ExpirationStatus
import 'package:intl/intl.dart'; // Per la formattazione delle date

/// ViewModel for the Car Detail screen.
/// Holds and manages the UI-related data and database operations for a single car.
/// Receives the car ID and the DAO as dependencies in the constructor, provided by the Factory.
/// Equivalente a CarDetailViewModel.kt.
class CarDetailViewModel extends ChangeNotifier {
  final int _carId;
  final CarDao _carDao;

  // Private Stream for the car, equivalent to Flow<Car?> in Kotlin.
  // The Stream emits a new value whenever the car in the database changes.
  Stream<Car?> get car => _carDao.getCarById(_carId);

  // Stato di caricamento.
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Messaggio di errore.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Messaggio di successo.
  String? _successMessage;
  String? get successMessage => _successMessage;

  CarDetailViewModel(this._carId, this._carDao);

  /// Validates the car data before saving.
  /// Returns a string resource ID (or equivalent message) if validation fails, null otherwise.
  /// Equivalente a fun validateCarData(carData: Car): Int? in Kotlin.
  String? validateCarData(Car carData) {
    // Validate brand and model: cannot be empty.
    if (carData.brand.isEmpty || carData.model.isEmpty) {
      return 'Brand and model cannot be empty.';
    }

    // Validate year: must be in a reasonable range.
    final currentYear = DateTime.now().year;
    if (carData.year < 1900 || carData.year > currentYear + 1) { // Allow current year + 1 for new models
      return 'Invalid year. Must be between 1900 and ${currentYear + 1}.';
    }

    // Validate RCA paid date: cannot be in the future.
    if (carData.rcaPaidDate != null && DateTime.fromMillisecondsSinceEpoch(carData.rcaPaidDate!)
        .isAfter(DateTime.now())) {
      return 'RCA paid date cannot be in the future.';
    }

    // Validate next revision date: cannot be in the past.
    if (carData.nextRevisionDate != null && DateTime.fromMillisecondsSinceEpoch(carData.nextRevisionDate!)
        .isBefore(DateTime.now().subtract(const Duration(days: 1)))) { // Allow today
      return 'Next revision date cannot be in the past.';
    }

    // Validate revision odometer: cannot be negative.
    if (carData.revisionOdometer != null && carData.revisionOdometer! < 0) {
      return 'Revision odometer must be positive.';
    }

    // Validate bollo cost: must be positive.
    if (carData.bolloCost != null && carData.bolloCost! <= 0) {
      return 'Bollo cost must be positive.';
    }

    return null; // Validation successful
  }

  /// Saves the changes to the car in the database.
  /// @param updatedCar The Car object with the updated data to save.
  /// Equivalente a fun saveCar(updatedCar: Car) in Kotlin.
  Future<void> saveCar(Car updatedCar) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    final validationError = validateCarData(updatedCar);
    if (validationError != null) {
      _errorMessage = validationError;
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      await _carDao.updateCar(updatedCar);
      _successMessage = 'Car saved successfully!';
      debugPrint('Car saved: ${updatedCar.id}');
    } catch (e) {
      _errorMessage = 'Error saving car: ${e.toString()}';
      debugPrint('Error saving car: $e');
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

  /// Resets the success message.
  void resetSuccessMessage() {
    _successMessage = null;
    notifyListeners();
  }

  /// Calculates the expiration status for a given timestamp.
  /// Equivalente a getExpirationStatus(timestamp: Long?): ExpirationStatus in Kotlin.
  ExpirationStatus getExpirationStatus(int? timestamp) {
    if (timestamp == null || timestamp == 0) {
      return ExpirationStatus.unknown;
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();

    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    if (compareDate.isBefore(today)) {
      return ExpirationStatus.expired;
    } else if (compareDate.isAtSameMomentAs(today)) {
      return ExpirationStatus.today;
    } else {
      final difference = compareDate.difference(today).inDays;
      if (difference <= 30) { // Near in Kotlin was <= 30 days
        return ExpirationStatus.near;
      } else {
        return ExpirationStatus.future;
      }
    }
  }

  /// Calculates the countdown text for a given timestamp and status.
  /// Equivalente a getCountdownText(timestamp: Long?, status: ExpirationStatus, context: Context): String in Kotlin.
  String getCountdownText(int? timestamp, ExpirationStatus status) {
    if (timestamp == null || timestamp == 0 || status == ExpirationStatus.unknown) {
      return 'N/A';
    }

    final date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final compareDate = DateTime(date.year, date.month, date.day);

    switch (status) {
      case ExpirationStatus.expired:
        final difference = today.difference(compareDate).inDays;
        if (difference == 0) {
          return 'Scaduto oggi';
        } else if (difference == 1) {
          return 'Scaduto ieri';
        } else {
          return 'Scaduto da $difference giorni';
        }
      case ExpirationStatus.today:
        return 'Scade oggi';
      case ExpirationStatus.near:
      case ExpirationStatus.future:
        final difference = compareDate.difference(today).inDays;
        if (difference == 0) {
          return 'Scade oggi'; // Should be handled by TODAY, but for safety
        } else if (difference == 1) {
          return 'Scade domani';
        } else if (difference <= 30) {
          return 'Scade tra $difference giorni';
        } else {
          final months = (difference / 30).floor(); // Approssimazione
          if (months > 0) {
            return 'Scade tra $months mesi';
          }
          return 'Scade tra $difference giorni'; // Fallback per giorni rimanenti
        }
      case ExpirationStatus.unknown:
        return 'N/A';
    }
  }
}
