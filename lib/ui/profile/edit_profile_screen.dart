import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/profile_view_model.dart';
import 'package:drivesafe/data/model/user.dart' as app_user;
import 'package:firebase_auth/firebase_auth.dart'; // To get the user's UID

/// Screen for editing user profile information.
class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _favoriteCarBrandController;
  late TextEditingController _placeOfBirthController;
  late TextEditingController _streetAddressController;
  late TextEditingController _cityOfResidenceController;
  late TextEditingController _yearOfBirthController;

  // Set to keep track of selected licenses (equivalent to MutableSet in Kotlin)
  final Set<String> _selectedLicenses = {};

  // Map of icons for license categories (as in ProfileScreen)
  final Map<String, IconData> _licenseCategoryIconMap = {
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

  // All available licenses (as in your Kotlin code)
  final List<String> _allLicenses = [
    "AM", "A1", "A2", "A", "B1", "B", "BE", "C1", "C1E", "C", "CE", "D1", "D1E", "D", "DE"
  ];

  @override
  void initState() {
    super.initState();
    final profileViewModel = Provider.of<ProfileViewModel>(context, listen: false);
    final user = profileViewModel.userProfile;

    _usernameController = TextEditingController(text: user?.username ?? '');
    _favoriteCarBrandController = TextEditingController(text: user?.favoriteCarBrand ?? '');
    _placeOfBirthController = TextEditingController(text: user?.placeOfBirth ?? '');
    _streetAddressController = TextEditingController(text: user?.streetAddress ?? '');
    _cityOfResidenceController = TextEditingController(text: user?.cityOfResidence ?? '');
    _yearOfBirthController = TextEditingController(text: user?.yearOfBirth?.toString() ?? '');

    // Initialize selected licenses
    if (user != null) {
      _selectedLicenses.addAll(user.licenses);
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _favoriteCarBrandController.dispose();
    _placeOfBirthController.dispose();
    _streetAddressController.dispose();
    _cityOfResidenceController.dispose();
    _yearOfBirthController.dispose();
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

  @override
  Widget build(BuildContext context) {
    final profileViewModel = Provider.of<ProfileViewModel>(context);


    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (profileViewModel.errorMessage != null) {
        _showSnackBar(profileViewModel.errorMessage!, isError: true);
        profileViewModel.resetErrorMessage();
      }
      if (profileViewModel.saveSuccessMessage != null) {
        _showSnackBar(profileViewModel.saveSuccessMessage!);
        profileViewModel.resetSaveSuccessMessage();
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifica Profilo'),
        centerTitle: true,
      ),
      body: profileViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: _usernameController,
                label: 'Username',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'username non può essere vuoto';
                  }
                  return null;
                },
              ),
              _buildTextField(
                controller: _favoriteCarBrandController,
                label: 'Marca Auto Preferita',
                icon: Icons.directions_car,
              ),
              _buildTextField(
                controller: _placeOfBirthController,
                label: 'Luogo di Nascita',
                icon: Icons.location_city,
              ),
              _buildTextField(
                controller: _streetAddressController,
                label: 'Indirizzo',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: _cityOfResidenceController,
                label: 'Città di Residenza',
                icon: Icons.location_city_outlined,
              ),
              _buildTextField(
                controller: _yearOfBirthController,
                label: 'Anno di Nascita',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final year = int.tryParse(value);
                    if (year == null || year < 1900 || year > DateTime.now().year) {
                      return 'Inserisci un anno valido (es. 1990)';
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(
                'Seleziona le tue licenze:',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: _allLicenses.map((license) {
                  final isSelected = _selectedLicenses.contains(license);
                  final mainCategory = license.replaceAll(RegExp(r'[^A-Za-z]'), '');
                  final iconData = _licenseCategoryIconMap[mainCategory] ?? Icons.category;

                  return FilterChip(
                    avatar: Icon(iconData, size: 18),
                    label: Text(license),
                    selected: isSelected,
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedLicenses.add(license);
                        } else {
                          _selectedLicenses.remove(license);
                        }
                      });
                    },
                    selectedColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    checkmarkColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    side: BorderSide(color: Theme.of(context).colorScheme.primary.withOpacity(0.5)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _saveProfile(profileViewModel);
                    }
                  },
                  icon: const Icon(Icons.save),
                  label: const Text('Salva Profilo'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
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
      ),
    );
  }

  /// Helper to build a text field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
          ),
          prefixIcon: Icon(icon),
        ),
        validator: validator,
      ),
    );
  }

  /// Saves the user profile.
  void _saveProfile(ProfileViewModel profileViewModel) {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      _showSnackBar('Errore: Utente non autenticato. Impossibile salvare il profilo.', isError: true);
      return;
    }

    final updatedUser = app_user.User(
      uid: currentUser.uid,
      email: currentUser.email ?? '',
      username: _usernameController.text,
      favoriteCarBrand: _favoriteCarBrandController.text,
      placeOfBirth: _placeOfBirthController.text,
      streetAddress: _streetAddressController.text,
      cityOfResidence: _cityOfResidenceController.text,
      yearOfBirth: int.tryParse(_yearOfBirthController.text),
      licenses: _selectedLicenses.toList(),
      registrationTimestamp: profileViewModel.userProfile?.registrationTimestamp,
    );

    profileViewModel.saveUserProfile(updatedUser);
  }
}