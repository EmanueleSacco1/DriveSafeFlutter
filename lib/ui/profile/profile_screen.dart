import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/profile_view_model.dart';
import 'package:drivesafe/data/model/user.dart' as app_user;
import 'package:drivesafe/ui/profile/edit_profile_screen.dart'; // For navigation to the edit screen
import 'package:firebase_auth/firebase_auth.dart'; // To access FirebaseAuth.instance.currentUser

/// Screen for displaying user profile information.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Access the ProfileViewModel.
    final profileViewModel = Provider.of<ProfileViewModel>(context);
    final user = profileViewModel.userProfile;

    return Scaffold(
      body: profileViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Nessun profilo utente trovato o caricato.'),
            if (profileViewModel.errorMessage != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  profileViewModel.errorMessage!,
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ElevatedButton(
              onPressed: () {
                // Try to reload the profile
                final uid = FirebaseAuth.instance.currentUser?.uid;
                if (uid != null) {
                  profileViewModel.fetchUserProfile(uid);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Utente non autenticato. Riprova il login.')),
                  );
                }
              },
              child: const Text('Riprova a caricare il profilo'),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileInfoCard(
              context,
              'Informazioni Personali',
              [
                _buildInfoRow('Email:', user.email),
                _buildInfoRow('Username:', user.username),
                _buildInfoRow('Marca Auto Preferita:', user.favoriteCarBrand),
                _buildInfoRow('Luogo di Nascita:', user.placeOfBirth),
                _buildInfoRow('Indirizzo:', user.streetAddress),
                _buildInfoRow('Città di Residenza:', user.cityOfResidence),
                _buildInfoRow('Anno di Nascita:', user.yearOfBirth?.toString() ?? 'N/A'),
              ],
              Icons.person,
            ),
            const SizedBox(height: 20),
            _buildLicensesCard(context, user.licenses),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Navigate to the edit profile screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.edit),
                label: const Text('Modifica Profilo'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  elevation: 5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper to build a profile information row.
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(value.isEmpty ? 'N/A' : value),
          ),
        ],
      ),
    );
  }

  /// Helper to build a card with profile information.
  Widget _buildProfileInfoCard(BuildContext context, String title, List<Widget> children, IconData icon) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 28, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  /// Helper to build the licenses card.
  Widget _buildLicensesCard(BuildContext context, List<String> licenses) {
    // Map of icons for license categories (as in your Kotlin code)
    final Map<String, IconData> licenseCategoryIconMap = {
      "A": Icons.motorcycle,
      "B": Icons.directions_car,
      "C": Icons.local_shipping,
      "D": Icons.bus_alert,
      "E": Icons.directions_car_filled,
      "AM": Icons.moped,
      "A1": Icons.motorcycle,
      "A2": Icons.motorcycle,
      "B1": Icons.directions_car,
      "C1": Icons.local_shipping,
      "D1": Icons.bus_alert,

    };

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.credit_card, size: 28, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Text(
                  'Licenze di Guida',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const Divider(height: 20, thickness: 1),
            if (licenses.isEmpty)
              const Text('Nessuna licenza registrata.')
            else
              Wrap(
                spacing: 8.0, // Horizontal space between chips
                runSpacing: 8.0, // Vertical space between chip rows
                children: licenses.map((license) {
                  // Extract the main category for the icon (e.g., "B" from "BE")
                  final mainCategory = license.replaceAll(RegExp(r'[^A-Za-z]'), '');
                  final iconData = licenseCategoryIconMap[mainCategory] ?? Icons.category; // Generic icon if not found

                  return Chip(
                    avatar: Icon(iconData, size: 18),
                    label: Text(license),
                    backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  );
                }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}