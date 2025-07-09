import 'package:flutter/material.dart';
import 'package:drivesafe/data/local/app_database.dart'; // Importa il database Drift
import 'package:drift/drift.dart' show Value; // Importa Value per CarsCompanion

/// ViewModel for the Garage screen.
/// Holds and manages the list of cars and the operations for adding/deleting cars.
/// It receives the DAO as a dependency in the constructor, provided by the Factory.
/// Equivalente a GarageViewModel.kt.
class GarageViewModel extends ChangeNotifier {
  final CarDao _carDao;

  // Public Stream for the list of cars, equivalent to Flow<List<Car>> in Kotlin.
  // This stream will emit a new list whenever the cars table changes.
  // It is used by the UI (Screen) to observe changes in the list of cars.
  Stream<List<Car>> get carList => _carDao.getAllCars();

  // Stato di caricamento (non strettamente necessario per operazioni semplici con Stream,
  // ma utile per operazioni Future come add/delete).
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Messaggio di errore per la UI.
  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  GarageViewModel(this._carDao);

  /// Adds a new car to the database.
  /// This is a suspend function because the database insertion is an operation that may take time
  /// and must be executed on a background thread (managed by Room/Coroutines).
  /// @param brand The brand of the new car.
  /// @param model The model of the new car.
  /// @param year The year of the new car.
  /// @return The generated ID (Long) for the newly inserted car.
  /// Equivalente a suspend fun addCar(brand: String, model: String, year: Int): Long in Kotlin.
  Future<int> addCar(String brand, String model, int year) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Crea un'istanza di CarsCompanion per l'inserimento.
      // L'ID è omesso perché autoIncrement lo gestirà.
      final newCar = CarsCompanion(
        brand: Value(brand),
        model: Value(model),
        year: Value(year),
      );
      final newId = await _carDao.insertCar(newCar);
      debugPrint('Car inserted with ID: $newId');
      return newId;
    } catch (e) {
      _errorMessage = 'Error adding car: ${e.toString()}';
      debugPrint('Error adding car: $e');
      return -1; // Indica un fallimento
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Deletes a car from the database.
  /// @param car The [Car] object to delete (must have a valid ID that exists in the DB).
  /// Equivalente a fun deleteCar(car: Car) in Kotlin.
  Future<void> deleteCar(Car car) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _carDao.deleteCar(car);
      debugPrint('Car with ID ${car.id} deleted.');
    } catch (e) {
      _errorMessage = 'Error deleting car: ${e.toString()}';
      debugPrint('Error deleting car: $e');
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
