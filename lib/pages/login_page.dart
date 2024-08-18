import 'package:flutter/material.dart';
import 'package:frontend/components/custom_text_field.dart';
import 'package:frontend/main_navigation.dart';
import 'package:frontend/utils/utilities.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const LoginPage({super.key, required this.onThemeChanged});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _lineIdController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  final Utilities _utils = Utilities();

  Future<void> _login() async {
    final lineId = _lineIdController.text.trim();
    final password = _passwordController.text.trim();

    // Validation 1: Check if fields are empty
    if (lineId.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Line ID and password cannot be empty.')),
      );
      return;
    }

    // Validation 2: Password length should be at least 8 characters
    if (password.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must be at least 8 characters long.')),
      );
      return;
    }

    // Validation 3: Password must be alphanumeric
    bool isAlphanumeric = true;
    for (int i = 0; i < password.length; i++) {
      final char = password[i];
      if (!_utils.isAlphaNumeric(char)) {
        isAlphanumeric = false;
        break;
      }
    }

    if (!isAlphanumeric) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Password must contain only letters and numbers.')),
      );
      return;
    }

    try {
      final response = await _authService.login(lineId, password);
      debugPrint('Login successful: ${response.lineId}');

      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('id', response.id);
      await prefs.setString('lineId', response.lineId);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PageNavigation(onThemeChanged: widget.onThemeChanged)),
        );
      }
    } catch (error) {
      // Handle login failure
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wrong credential')),
        );
      }
      // debugPrint('Login failed: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Logo
            Center(
              child: Image.asset(
                'assets/logo.png', // Path to your logo image
                height: 140.0,
              ),
            ),
            const SizedBox(height: 50.0),
            // Line ID Field
            CustomTextField(
              labelText: 'Line ID',
              icon: Icons.account_circle,
              controller: _lineIdController,
            ),
            const SizedBox(height: 20.0),
            // Password Field
            CustomTextField(
              labelText: 'Password',
              icon: Icons.lock,
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 40.0),
            // Login Button
            ElevatedButton(
              onPressed: _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00D563), // Webtoon Green
                padding: const EdgeInsets.symmetric(vertical: 16.0),
              ),
              child: const Text(
                'Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
