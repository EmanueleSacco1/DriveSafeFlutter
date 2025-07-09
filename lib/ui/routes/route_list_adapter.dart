import 'package:flutter/material.dart';
import 'package:drivesafe/data/model/route.dart' as app_route; // Alias for your Route model
import 'package:intl/intl.dart'; // For date formatting

/// Interface to define callbacks for route item click events.
abstract class OnItemClickListener {
  /// Called when a route item has been clicked.
  void onItemClick(app_route.Route route);
}

/// A [ListView.builder] to display a list of [Route] objects.
class RouteListAdapter extends StatelessWidget {
  final Map<String, String> usersMap;
  final List<app_route.Route> routes;
  final OnItemClickListener onItemClick;

  const RouteListAdapter({
    super.key,
    required this.usersMap,
    required this.routes,
    required this.onItemClick,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy HH:mm');

    return ListView.builder(
      itemCount: routes.length,
      itemBuilder: (context, index) {
        final route = routes[index];
        final userName = usersMap[route.userId] ?? 'Utente Sconosciuto';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () => onItemClick.onItemClick(route),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Percorso di $userName',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Data: ${dateFormat.format(DateTime.fromMillisecondsSinceEpoch(route.timestamp))}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Distanza: ${(route.totalDistance / 1000).toStringAsFixed(2)} km',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(
                    'Velocità Media: ${(route.averageSpeed * 3.6).toStringAsFixed(2)} km/h',
                    style: Theme.of(context).textTheme.titleMedium,
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