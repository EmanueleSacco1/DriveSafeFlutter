import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/auth_view_model.dart';

/// The Login Screen widget.
///
/// This screen provides a user interface for users to log in to the application.
/// It is stateful to manage form input and interaction with the [AuthViewModel].
class LoginScreen extends StatefulWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controllers for the email and password text fields.
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // GlobalKey to manage the state of the Form widget for validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Dispose of the text controllers when the widget is removed from the widget tree
    // to free up resources.
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Displays a SnackBar message to the user.
  ///
  /// This is similar to a Toast or Snackbar in native Android development.
  ///
  /// The [message] is the text to display.
  /// If [isError] is true, the SnackBar will have a red background; otherwise, green.
  void _showSnackBar(String message, {bool isError = false}) {
    // Ensure the widget is still mounted before trying to show a SnackBar.
    if (!mounted) return;
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
    // Access the AuthViewModel using Provider.
    // `listen: true` is the default, so this widget will rebuild if AuthViewModel notifies listeners.
    final authViewModel = Provider.of<AuthViewModel>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.errorMessage != null) {
        _showSnackBar(authViewModel.errorMessage!, isError: true);
        authViewModel.resetMessages(); // Reset the message in the ViewModel
      }
      if (authViewModel.successMessage != null) {
        _showSnackBar(authViewModel.successMessage!);
        authViewModel.resetMessages(); // Reset the message in the ViewModel
        Navigator.of(context).pushReplacementNamed('/main');
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'), // Title of the login screen
        centerTitle: true, // Centers the title in the AppBar
      ),
      body: Center( // Centers the content of the body
        child: SingleChildScrollView( // Allows scrolling if content overflows
          padding: const EdgeInsets.all(16.0), // Padding around the form
          child: Form(
            key: _formKey, // Assign the GlobalKey to the Form
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers the column content vertically
              children: <Widget>[
                // Email input field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la tua email'; // Validation message for empty email
                    }
                    if (!value.contains('@')) {
                      return 'Inserisci un\'email valida'; // Validation message for invalid email format
                    }
                    return null; // Return null if validation passes
                  },
                ),
                const SizedBox(height: 16.0), // Spacing between fields
                // Password input field
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Hides the password input
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    ),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Inserisci la tua password'; // Validation message for empty password
                    }
                    return null; // Return null if validation passes
                  },
                ),
                const SizedBox(height: 24.0), // Spacing before the login button
                // Login button or loading indicator
                authViewModel.isLoading
                    ? const CircularProgressIndicator() // Show a loading indicator if login is in progress
                    : ElevatedButton(
                  onPressed: () {
                    // Validate the form before attempting to sign in
                    if (_formKey.currentState?.validate() ?? false) {
                      authViewModel.signInUser(
                        _emailController.text,
                        _passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5, // Adds a shadow to the button
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(height: 16.0), // Spacing
                // Navigation to Registration Screen
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/register');
                  },
                  child: const Text('Non hai un account? Registrati'),
                ),
                // Navigation to Password Reset Screen
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('/reset_password');
                  },
                  child: const Text('Hai dimenticato la password?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}