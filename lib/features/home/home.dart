import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/shared/tasks/dailys/daily.dart'; // Repozytorium Daily
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart'; // Model Daily
import 'package:habbitapp/features/components/upper_pannel/upper_panel.dart';


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

// Główna strona aplikacji
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          UpperPanel(
            title: Provider.of<UserProvider>(context).username ?? '?',
            onIconPressed: () {
              print("Calendar icon pressed");
            },
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 500, // Maksymalna szerokość listy
                child: DailyList(), // Lista zadań Daily
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Lista zadań pobranych z DailyRepository
class DailyList extends StatelessWidget {
  const DailyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Pobranie instancji repozytorium przez Provider
    final dailyRepository = Provider.of<DailyRepository>(context);
    final dailys = dailyRepository.getAll();

    if (dailys.isEmpty) {
      return const Center(child: Text('No tasks available')); // Komunikat dla pustej listy
    }

    // Budowa listy zadań
    return ListView.builder(
      itemCount: dailys.length,
      itemBuilder: (context, index) {
        final daily = dailys[index];
        return TaskItem(daily: daily); // Każdy element listy to TaskItem
      },
    );
  }
}



// Pojedynczy element listy zadań Daily
class TaskItem extends StatelessWidget {
  final Daily daily;

  const TaskItem({Key? key, required this.daily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE9D5FF), // Kolor tła karty
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight( // Dodajemy IntrinsicHeight
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch, // Rozciąganie wiersza na całą wysokość
          children: [
            // Lewa część - koło i prostokąt
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: daily.taskColor, // Kolor prostokąta
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Koło - wyśrodkowane
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      color: daily.circleColor, // Kolor koła
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            // Prawa część - tekst
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      daily.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      daily.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Prawa część - ikony
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: daily.circleColor,
                    child: Text(
                      '${daily.streak}',
                      style: const TextStyle(fontSize: 12, color: Colors.black),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.double_arrow, color: Colors.black, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class ChartWithLabel extends StatelessWidget {
  final String label;
  final double value;

  const ChartWithLabel({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 100, // Wysokość wykresu
            width: 100,  // Szerokość wykresu
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: HabiticaColors.teal10,
                        value: value,
                        radius: 15,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        color: Colors.grey[300],
                        value: 100 - value,
                        radius: 15,
                        showTitle: false,
                      ),
                    ],
                    centerSpaceRadius: 30,
                  ),
                ),
                Text(
                  '${value.toInt()}', // Liczba w środku wykresu
                  style: const TextStyle(

                    fontSize: 16,
                    fontWeight: FontWeight.bold, color: Color(0xE6FFFFFF)
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 120, // Ograniczenie szerokości tekstu
            child: Text(
              label,
              textAlign: TextAlign.center, // Wyśrodkowanie tekstu
              softWrap: true, // Włączenie zawijania
              style: const TextStyle(fontSize: 14, color: Color(0xE6FFFFFF)),
            ),
          ),
        ],
      ),
    );
  }
}
