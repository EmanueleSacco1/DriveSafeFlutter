import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:drivesafe/viewmodels/auth_view_model.dart';

/// A screen for resetting user password.
class ResetPasswordScreen extends StatefulWidget {
  /// Creates a [ResetPasswordScreen].
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  // A global key for the form to enable validation.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  /// Shows a Snackbar message (equivalent to Toast or Snackbar in Android).
  ///
  /// The [message] is the text to display.
  /// Set [isError] to true to display the Snackbar with a red background for errors,
  /// otherwise it will have a green background.
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
    // Obtain the AuthViewModel from the Provider.
    final authViewModel = Provider.of<AuthViewModel>(context);

    // Listen for success or error messages from the ViewModel
    // and display them in a Snackbar.
    // This callback is scheduled for after the current frame has been rendered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authViewModel.errorMessage != null) {
        _showSnackBar(authViewModel.errorMessage!, isError: true);
        // Reset the error message in the ViewModel to prevent it from being shown again.
        authViewModel.resetMessages();
      }
      if (authViewModel.successMessage != null) {
        _showSnackBar(authViewModel.successMessage!);
        // Reset the success message in the ViewModel.
        authViewModel.resetMessages();
        // Navigate back to the login screen after successfully sending the reset email.
        Navigator.of(context).pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
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
                      return 'Inserisci la tua email';
                    }
                    if (!value.contains('@')) {
                      return 'Inserisci un\'email valida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24.0),
                // Show a loading indicator while the password reset email is being sent.
                authViewModel.isLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                  onPressed: () {
                    // Validate the form before attempting to send the reset email.
                    if (_formKey.currentState?.validate() ?? false) {
                      // Call the sendPasswordResetEmail method in the AuthViewModel.
                      authViewModel.sendPasswordResetEmail(
                        _emailController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Invia Email Reset Password',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}