import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Przykładowe zadania
    final List<String> tasks = [
      'My task is to do something',
      'My task is to do anything',
      'Not to play on computer',
      'Not to use mobile phone',
      'Not to use mobile phone',
      'Not to use mobile phone',
      'Not to use mobile phone',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Row z wykresami kołowymi
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChartWithLabel(label: 'Longest streak', value: 80),
                      ChartWithLabel(label: 'Hardest streak', value: 60),
                      ChartWithLabel(label: 'Days without missing a task', value: 90),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lista zadań:',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(
                      0xE6FFFFFF)),
                ),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 450),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(), // Zapobiega konfliktom z SingleChildScrollView
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      return TaskItem(
                        title: tasks[index],
                        onLeftTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Left side tapped on: ${tasks[index]}')),
                          );
                        },
                        onRightTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Right side tapped on: ${tasks[index]}')),
                          );
                        },
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        )
      ),
    );
  }
}

class TaskItem extends StatelessWidget {
  final String title;
  final VoidCallback onLeftTap;
  final VoidCallback onRightTap;

  const TaskItem({
    Key? key,
    required this.title,
    required this.onLeftTap,
    required this.onRightTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE9D5FF), // Fioletowe tło karty
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20), // Zaokrąglenie krawędzi
        side: const BorderSide(color: Color(0xFF8A4DB3), width: 4), // Fioletowa obwódka
      ),
      child: Row(
        children: [
          // Lewa część - koło i prostokąt w Stack
          GestureDetector(
            onTap: onLeftTap,
            child: Container(
              width: 60, // Szerokość lewej części
              height: 80,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Prostokąt pod kołem
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: 60,
                      height: 80, // Wysokość prostokąta
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6FCB4), // Żółty kolor
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  // Koło na górze
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE1E740), // Żółte tło koła
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Prawa część
          Expanded(
            child: GestureDetector(
              onTap: onRightTap,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                child: Row(
                  children: [
                    // Tytuł zadania
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    // Numer i ikona
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Color(0xFFFFF89D),
                          child: Text(
                            '5',
                            style: TextStyle(fontSize: 12, color: Colors.black),
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.double_arrow, color: Colors.black, size: 18),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class TaskListScreen extends StatelessWidget {
  const TaskListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lista zadań
    final List<String> tasks = [
      'My task is to do something',
      'My task is to do anything',
      'Not to play on computer',
      'Not to use mobile phone',
      'Not to use mobile phone',
      'Not to use mobile phone',
      'Not to use mobile phone',
      'Not to use mobile phone',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return TaskItem(
            title: tasks[index],
            onLeftTap: () {
              // Kliknięcie lewej części
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Left side tapped on: ${tasks[index]}')),
              );
            },
            onRightTap: () {
              // Kliknięcie prawej części
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Right side tapped on: ${tasks[index]}')),
              );
            },
          );
        },
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
                        color: Color(0xFFFCBA04),
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
