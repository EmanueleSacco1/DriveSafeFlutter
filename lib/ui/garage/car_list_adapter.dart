import 'package:flutter/material.dart';
import 'package:drivesafe/data/local/app_database.dart'; // Importa la classe Car dal file .dart originale

/// Interface to define callbacks for item click events.
/// The Screen (or whatever uses the adapter) must implement this interface.
abstract class OnCarClickListener {
  /// Called when the entire car item is clicked.
  /// @param car The [Car] object corresponding to the clicked item.
  void onCarClick(Car car);

  /// Called when the delete button on the car item is clicked.
  /// @param car The [Car] object corresponding to the item to be deleted.
  void onDeleteCarClick(Car car);
}

/// Custom Adapter for the RecyclerView in the [GarageScreen].
/// It is responsible for taking data (a list of [Car] objects) and creating/updating the Views
/// for each item in the list to be displayed in the RecyclerView.
class CarListAdapter extends StatelessWidget {
  final List<Car> cars;
  final OnCarClickListener listener;

  const CarListAdapter({
    super.key,
    required this.cars,
    required this.listener,
  });

  @override
  Widget build(BuildContext context) {
    if (cars.isEmpty) {
      return const Center(
        child: Text(
          'Nessuna auto aggiunta. Tocca il pulsante "+" per aggiungerne una.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      itemCount: cars.length,
      itemBuilder: (context, index) {
        final car = cars[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => listener.onCarClick(car), // Gestisce il click sull'intera card
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.directions_car, size: 40, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${car.brand} ${car.model}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Anno: ${car.year}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => listener.onDeleteCarClick(car), // Gestisce il click sul pulsante elimina
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
