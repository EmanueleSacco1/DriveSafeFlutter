import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/car_detail_view_model.dart';
import 'package:drivesafe/data/local/app_database.dart'; // Import the Car class from the original .dart file
import 'package:drivesafe/data/model/expiration_status.dart'; // Import the ExpirationStatus enum
import 'package:intl/intl.dart'; // For date formatting

/// Screen to display and edit the details of a single car.
/// It observes the car data (exposed as a Stream) from its associated ViewModel.

class CarDetailScreen extends StatefulWidget {
  final int carId; // The ID of the car to display/edit

  const CarDetailScreen({super.key, required this.carId});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _brandController;
  late TextEditingController _modelController;
  late TextEditingController _yearController;
  late TextEditingController _rcaPaidDateController;
  late TextEditingController _nextRevisionDateController;
  late TextEditingController _revisionOdometerController;
  late TextEditingController _registrationDateController;
  late TextEditingController _bolloCostController;
  late TextEditingController _bolloExpirationDateController;

  Car? _currentCar; // To keep track of the current car and initialize controllers

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty or default values.
    // They will be populated when car data becomes available.
    _brandController = TextEditingController();
    _modelController = TextEditingController();
    _yearController = TextEditingController();
    _rcaPaidDateController = TextEditingController();
    _nextRevisionDateController = TextEditingController();
    _revisionOdometerController = TextEditingController();
    _registrationDateController = TextEditingController();
    _bolloCostController = TextEditingController();
    _bolloExpirationDateController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Listen to the car stream to populate controllers when data is available.
    Provider.of<CarDetailViewModel>(context, listen: false)
        .car
        .listen((car) {
      if (car != null && car != _currentCar) {
        setState(() {
          _currentCar = car;
          _brandController.text = car.brand;
          _modelController.text = car.model;
          _yearController.text = car.year.toString();
          _rcaPaidDateController.text = car.rcaPaidDate != null
              ? DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(car.rcaPaidDate!))
              : '';
          _nextRevisionDateController.text = car.nextRevisionDate != null
              ? DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(car.nextRevisionDate!))
              : '';
          _revisionOdometerController.text = car.revisionOdometer?.toString() ?? '';
          _registrationDateController.text = car.registrationDate != null
              ? DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(car.registrationDate!))
              : '';
          _bolloCostController.text = car.bolloCost?.toStringAsFixed(2) ?? '';
          _bolloExpirationDateController.text = car.bolloExpirationDate != null
              ? DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(car.bolloExpirationDate!))
              : '';
        });
      }
    });
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _yearController.dispose();
    _rcaPaidDateController.dispose();
    _nextRevisionDateController.dispose();
    _revisionOdometerController.dispose();
    _registrationDateController.dispose();
    _bolloCostController.dispose();
    _bolloExpirationDateController.dispose();
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

  /// Shows a DatePicker and updates the text controller.
  Future<void> _selectDate(BuildContext context, TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      controller.text = DateFormat('dd/MM/yyyy').format(picked);
    }
  }

  /// Helper to build a text field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        readOnly: readOnly,
        onTap: onTap,
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

  /// Helper to build an expiration status card.
  Widget _buildExpirationStatusCard(
      BuildContext context,
      String title,
      int? timestamp,
      ExpirationStatus status,
      String countdownText,
      ) {
    Color statusColor;
    switch (status) {
      case ExpirationStatus.expired:
        statusColor = Colors.red.shade700;
        break;
      case ExpirationStatus.today:
      case ExpirationStatus.near:
        statusColor = Colors.orange.shade700;
        break;
      case ExpirationStatus.future:
        statusColor = Colors.green.shade700;
        break;
      case ExpirationStatus.unknown:
        statusColor = Colors.grey;
        break;
    }

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 10, thickness: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  timestamp != null && timestamp != 0
                      ? DateFormat('dd/MM/yyyy').format(DateTime.fromMillisecondsSinceEpoch(timestamp))
                      : 'Data non definita', // 'Date not defined'
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  countdownText,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: statusColor, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Use a Consumer to rebuild only the part that depends on the ViewModel
    return Consumer<CarDetailViewModel>(
      builder: (context, carDetailViewModel, child) {
        // Listen for success or error messages from the ViewModel.
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (carDetailViewModel.errorMessage != null) {
            _showSnackBar(carDetailViewModel.errorMessage!, isError: true);
            carDetailViewModel.resetErrorMessage();
          }
          if (carDetailViewModel.successMessage != null) {
            _showSnackBar(carDetailViewModel.successMessage!);
            carDetailViewModel.resetSuccessMessage();
            Navigator.of(context).pop(); // Go back to the previous screen after saving
          }
        });

        final carData = _currentCar; // Use the car from didChangeDependencies

        if (carDetailViewModel.isLoading && carData == null) {
          return const Center(child: CircularProgressIndicator());
        }

        if (carData == null) {
          return const Center(child: Text('Dettagli auto non disponibili.'));
        }

        // Calculate expiration statuses
        final rcaStatus = carDetailViewModel.getExpirationStatus(carData.rcaPaidDate);
        final rcaCountdown = carDetailViewModel.getCountdownText(carData.rcaPaidDate, rcaStatus);

        final revisionStatus = carDetailViewModel.getExpirationStatus(carData.nextRevisionDate);
        final revisionCountdown = carDetailViewModel.getCountdownText(carData.nextRevisionDate, revisionStatus);

        final bolloStatus = carDetailViewModel.getExpirationStatus(carData.bolloExpirationDate);
        final bolloCountdown = carDetailViewModel.getCountdownText(carData.bolloExpirationDate, bolloStatus);

        return Scaffold(
          appBar: AppBar(
            title: Text('${carData.brand} ${carData.model}'),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextField(
                    controller: _brandController,
                    label: 'Marca',
                    icon: Icons.branding_watermark,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La marca non può essere vuota';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _modelController,
                    label: 'Modello',
                    icon: Icons.model_training,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Il modello non può essere vuoto';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _yearController,
                    label: 'Anno',
                    icon: Icons.calendar_today,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'L\'anno non può essere vuoto';
                      }
                      final year = int.tryParse(value);
                      if (year == null || year < 1900 || year > DateTime.now().year + 1) {
                        return 'Anno non valido';
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _rcaPaidDateController,
                    label: 'Data Pagamento RCA',
                    icon: Icons.date_range,
                    readOnly: true,
                    onTap: () => _selectDate(context, _rcaPaidDateController),
                  ),
                  _buildExpirationStatusCard(
                    context,
                    'Stato RCA',
                    carData.rcaPaidDate,
                    rcaStatus,
                    rcaCountdown,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _nextRevisionDateController,
                    label: 'Data Prossima Revisione',
                    icon: Icons.date_range,
                    readOnly: true,
                    onTap: () => _selectDate(context, _nextRevisionDateController),
                  ),
                  _buildExpirationStatusCard(
                    context,
                    'Stato Revisione',
                    carData.nextRevisionDate,
                    revisionStatus,
                    revisionCountdown,
                  ),
                  const SizedBox(height: 10),
                  _buildTextField(
                    controller: _revisionOdometerController,
                    label: 'Chilometraggio Revisione (km)',
                    icon: Icons.speed,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final odometer = int.tryParse(value);
                        if (odometer == null || odometer < 0) {
                          return 'Chilometraggio non valido';
                        }
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _registrationDateController,
                    label: 'Data Immatricolazione',
                    icon: Icons.date_range,
                    readOnly: true,
                    onTap: () => _selectDate(context, _registrationDateController),
                  ),
                  _buildTextField(
                    controller: _bolloCostController,
                    label: 'Costo Bollo (€)',
                    icon: Icons.money,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value != null && value.isNotEmpty) {
                        final cost = double.tryParse(value);
                        if (cost == null || cost <= 0) {
                          return 'Costo bollo non valido';
                        }
                      }
                      return null;
                    },
                  ),
                  _buildTextField(
                    controller: _bolloExpirationDateController,
                    label: 'Data Scadenza Bollo',
                    icon: Icons.date_range,
                    readOnly: true,
                    onTap: () => _selectDate(context, _bolloExpirationDateController),
                  ),
                  _buildExpirationStatusCard(
                    context,
                    'Stato Bollo',
                    carData.bolloExpirationDate,
                    bolloStatus,
                    bolloCountdown,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      onPressed: carDetailViewModel.isLoading
                          ? null
                          : () {
                        if (_formKey.currentState?.validate() ?? false) {
                          _saveCar(carDetailViewModel, carData.id);
                        }
                      },
                      icon: const Icon(Icons.save),
                      label: const Text('Salva Modifiche'),
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
      },
    );
  }

  /// Saves the car details.
  void _saveCar(CarDetailViewModel viewModel, int carId) {
    final updatedCar = Car(
      id: carId,
      brand: _brandController.text,
      model: _modelController.text,
      year: int.parse(_yearController.text),
      rcaPaidDate: _rcaPaidDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_rcaPaidDateController.text).millisecondsSinceEpoch
          : null,
      nextRevisionDate: _nextRevisionDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_nextRevisionDateController.text).millisecondsSinceEpoch
          : null,
      revisionOdometer: int.tryParse(_revisionOdometerController.text),
      registrationDate: _registrationDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_registrationDateController.text).millisecondsSinceEpoch
          : null,
      bolloCost: double.tryParse(_bolloCostController.text),
      bolloExpirationDate: _bolloExpirationDateController.text.isNotEmpty
          ? DateFormat('dd/MM/yyyy').parse(_bolloExpirationDateController.text).millisecondsSinceEpoch
          : null,
    );
    viewModel.saveCar(updatedCar);
  }
}