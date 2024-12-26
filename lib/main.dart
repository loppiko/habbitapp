import 'package:flutter/material.dart';
import 'package:habbitapp/features/home/daily_view.dart';
import 'package:habbitapp/features/login/login.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/habits/habit_repository.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';
import 'features/todo_view/todo_view.dart';
import 'features/habit_view/habit_view.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TodosRepository()),
        ChangeNotifierProvider(create: (_) => DailyRepository()),
        ChangeNotifierProvider(create: (_) => HabitRepository()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        scaffoldBackgroundColor: HabiticaColors.purple100,
      ),
        home: LoginScreen(), // Główny ekran aplikacji
    );
  }
}


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  bool _isHighlighted = false;

  final List<Widget> _pages = [
    CalendarScreen(),
    HomeScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Wyświetlanie aktualnego ekranu
          _pages[_selectedIndex],

          // Trójkątny przycisk umieszczony nad paskiem nawigacyjnym
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 30,
            bottom: 0,
            child: Material( // Dodajemy Material
              color: Colors.transparent, // Ważne: tło musi być przezroczyste
              child: InkWell( // Używamy InkWell dla animacji "ripple"
                onTap: () {
                  if (_selectedIndex == 0) {
                    print("Calendar Button Pressed");
                  } else if (_selectedIndex == 1) {
                    print("Home Button Pressed");
                  } else {
                    print("Habits Button Pressed");
                  }
                },
                onHighlightChanged: (isHighlighted) {
                  setState(() {
                    _isHighlighted = isHighlighted;
                  });
                },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(60, 45),
                        painter: TrianglePainter(
                          color: _isHighlighted
                              ? HabiticaColors.purple400
                              : HabiticaColors.purple300,
                        ),
                      ),
                      Padding( // Dodajemy Padding
                        padding: const EdgeInsets.only(top: 9.0),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ],
          ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: HabiticaColors.purple100,
        currentIndex: _selectedIndex,
        selectedItemColor: HabiticaColors.gray700, // Kolor aktywnego przycisku
        unselectedItemColor: HabiticaColors.purple400,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home), // Brak ikony na tej pozycji
            label: 'Home', // Pusty label, bo przycisk jest niestandardowy
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.exposure),
            label: 'Habits',
          ),
        ],
      ),
    );
  }
}

// Klasa do rysowania trójkąta
class TrianglePainter extends CustomPainter {
  final Color color;

  TrianglePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..color = color; // Używamy przekazanego koloru
    final Path path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width / 2, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant TrianglePainter oldDelegate) {
    return color != oldDelegate.color;
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
