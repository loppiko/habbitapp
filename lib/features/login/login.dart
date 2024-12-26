import 'package:flutter/material.dart';
import 'package:habbitapp/main.dart';
import 'package:habbitapp/shared/api/api_service.dart';
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart';
import 'package:habbitapp/shared/tasks/habits/habit_repository.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:provider/provider.dart';

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

    final response = await ApiService.login(context, username, password);

    if (response.containsKey('token')) {
      // Pobieranie danych po udanym zalogowaniu
      final todosRepository = Provider.of<TodosRepository>(context, listen: false);
      final dailyRepository = Provider.of<DailyRepository>(context, listen: false);
      final habitRepository = Provider.of<HabitRepository>(context, listen: false);

      todosRepository.downloadHabiticaTodos();
      dailyRepository.downloadHabiticaDailys();
      habitRepository.downloadHabiticaHabits();

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
          constraints: const BoxConstraints(maxWidth: 500),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Image.asset(
                    'assets/images/habitica_logo.png',
                    height: 200,
                  ),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: HabiticaColors.purple50,
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: HabiticaColors.purple50,
                  ),
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 32),
                LoginButton(onPressed: _handleLogin),
                const SizedBox(height: 32),
                if (message.isNotEmpty)
                  Text(
                    message,
                    style: TextStyle(
                      color: message == 'Invalid credentials!' ? Colors.red : Colors.green,
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


