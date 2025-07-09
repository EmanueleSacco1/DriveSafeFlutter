import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/garage_view_model.dart';
import 'package:drivesafe/data/local/app_database.dart'; // Import the Car class from the original .dart file
import 'package:drivesafe/ui/garage/car_list_adapter.dart'; // Import the adapter
import 'package:drivesafe/ui/cardetail/car_detail_screen.dart'; // For navigation to car details

/// Screen for displaying the list of cars and adding new ones.
/// Implements [OnCarClickListener] to handle item click events.
class GarageScreen extends StatefulWidget {
  const GarageScreen({super.key});

  @override
  State<GarageScreen> createState() => _GarageScreenState();
}

class _GarageScreenState extends State<GarageScreen> implements OnCarClickListener {
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    super.dispose();
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

  /// Shows the dialog to add a new car.
  void _showAddCarDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Aggiungi Nuova Auto'), // 'Add New Car'
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _brandController,
                    decoration: const InputDecoration(labelText: 'Marca'), // 'Brand'
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci la marca'; // 'Please enter the brand'
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _modelController,
                    decoration: const InputDecoration(labelText: 'Modello'), // 'Model'
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il modello'; // 'Please enter the model'
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Anno'), // 'Year'
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci l\'anno'; // 'Please enter the year'
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                        return 'Anno non valido'; // 'Invalid year'
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'), // 'Cancel'
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _brandController.clear();
                _modelController.clear();
                _yearController.clear();
              },
            ),
            ElevatedButton(
              child: const Text('Aggiungi'), // 'Add'
              onPressed: () {
                if (_formKey.currentState?.validate() ?? false) {
                  final brand = _brandController.text;
                  final model = _modelController.text;
                  final year = int.parse(_yearController.text);

                  Provider.of<GarageViewModel>(context, listen: false)
                      .addCar(brand, model, year)
                      .then((newId) {
                    if (newId != -1) {
                      _showSnackBar('Auto aggiunta con successo!'); // 'Car added successfully!'
                      Navigator.of(dialogContext).pop(); // Closes the dialog
                      _brandController.clear();
                      _modelController.clear();
                      _yearController.clear();
                    }
                  });
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// Shows the confirmation dialog for deleting a car.
  void _showDeleteConfirmationDialog(Car car) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Elimina Auto'),
          content: Text('Sei sicuro di voler eliminare ${car.brand} ${car.model} (${car.year})?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Annulla'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Elimina'),
              onPressed: () {
                Provider.of<GarageViewModel>(context, listen: false)
                    .deleteCar(car)
                    .then((_) {
                  _showSnackBar('Auto eliminata: ${car.brand} ${car.model}');
                  Navigator.of(dialogContext).pop();
                });
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final garageViewModel = Provider.of<GarageViewModel>(context);

    // Listen for error messages from the ViewModel.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (garageViewModel.errorMessage != null) {
        _showSnackBar(garageViewModel.errorMessage!, isError: true);
        garageViewModel.resetErrorMessage();
      }
    });

    return Scaffold(
      body: StreamBuilder<List<Car>>(
        stream: garageViewModel.carList, // Observe the car stream
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Errore nel caricamento delle auto: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Nessuna auto aggiunta. Tocca il pulsante "+" per aggiungerne una.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else {
            // If there's data, display the list of cars
            return CarListAdapter(
              cars: snapshot.data!,
              listener: this, // Pass the screen as the listener for clicks
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddCarDialog(context),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        child: const Text(
          '+',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  @override
  void onCarClick(Car car) {
    // Navigate to the car details screen
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CarDetailScreen(carId: car.id),
      ),
    );
  }

  @override
  void onDeleteCarClick(Car car) {
    _showDeleteConfirmationDialog(car);
  }
}