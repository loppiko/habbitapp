import 'package:flutter/material.dart';
import 'package:habbitapp/features/login/login.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';
import 'features/home/home.dart';
import 'features/todo_view/todo_view.dart';
import 'features/profile/profile.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TodosRepository()),
        ChangeNotifierProvider(create: (_) => DailyRepository()),
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
  @override
  void initState() {
    super.initState();


    Future.delayed(Duration.zero, () {
      Provider.of<TodosRepository>(context, listen: false)
          .downloadHabiticaTodos();
    });

    Future.delayed(Duration.zero, () {
      Provider.of<DailyRepository>(context, listen: false)
          .downloadHabiticaDailys();
    });
  }

  int _selectedIndex = 0;
  final List<Widget> _pages = [
    CalendarScreen(),
    const HomeScreen(),
    const ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: _pages[_selectedIndex], // Wyświetlenie aktualnego ekranu
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Calendar'),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.exposure), label: 'Habits'),
        ],
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
