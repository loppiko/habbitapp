import 'package:flutter/material.dart';
import 'features/home/home.dart';
import 'features/calendar/calendar.dart';
import 'features/profile/profile.dart';
import 'features/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent, // Przezroczyste tło dla Scaffold
      ),
      // Użycie LoginScreen() jako ekranu początkowego
      home: LoginScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // Lista ekranów
  final List<Widget> _pages = [
    const CalendarScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  // Obsługa zmiany indeksu
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground( // Dodanie gradientu na całość ekranu
      child: Scaffold(
        backgroundColor: Colors.transparent, // Przezroczyste tło
        body: _pages[_selectedIndex], // Wyświetlenie aktywnego ekranu
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          currentIndex: _selectedIndex, // Indeks aktywnego elementu
          onTap: _onItemTapped, // Obsługa kliknięcia
          selectedItemColor: Colors.white, // Kolor zaznaczenia
          unselectedItemColor: const Color(0xFFBBA6FF), // Kolor nieaktywnego elementu
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month),
              label: 'Calendar',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// GradientBackground Widget
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xE62B1A4A),
            Color(0xBF2B1A4A),
            Color(0xFF452E70),
            Color(0xFF452E70),
            Color(0xFF452E70),
            Color(0xFF452E70),
            Color(0xBF2B1A4A),
            Color(0xE62B1A4A),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child, // Zawartość - Scaffold z BottomNavigationBar
    );
  }
}
