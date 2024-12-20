import 'package:flutter/material.dart';
import 'package:habbitapp/main.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String message = '';

  void _handleLogin() async {
    String username = usernameController.text;
    String password = passwordController.text;

    final response = await ApiService.login(username, password);

    if (response.containsKey('token')) {
      final repository = TodosRepository();
      repository.downloadHabiticaTodos();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      setState(() {
        message = response['error'] ?? 'Login failed!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500), // Maksymalna szerokość kontenera
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo aplikacji
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0), // Odstęp poniżej logo
                  child: Image.asset(
                    'assets/images/habitica_logo.png', // Ścieżka do logo
                    height: 200, // Wysokość logo
                  ),
                ),
                // Pole Username
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white), // Kolor etykiety
                    // border: OutlineInputBorder(),
                    filled: true, // Włączenie wypełnienia tła
                    fillColor: HabiticaColors.purple50
                  ),
                  style: const TextStyle(color: Colors.white), // Kolor tekstu
                ),
                const SizedBox(height: 16),
                // Pole Password
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white), // Kolor etykiety
                    // border: OutlineInputBorder(),
                    filled: true, // Włączenie wypełnienia tła
                    fillColor: HabiticaColors.purple50
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white), // Kolor tekstu
                ),
                const SizedBox(height: 32),
                // Przycisk Login
                LoginButton(
                  onPressed: _handleLogin,
                ),

                const SizedBox(height: 32),
                // Wiadomość o błędzie
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                      color: message == 'Invalid credentials!'
                          ? Colors.red
                          : Colors.green,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class LoginButton extends StatelessWidget {
  final VoidCallback onPressed; // Funkcja obsługująca zdarzenie kliknięcia

  const LoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          minWidth: 300,
          maxWidth: 400,
        ),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: HabiticaColors.teal10,
            minimumSize: const Size(200, 50),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            'Login',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}


