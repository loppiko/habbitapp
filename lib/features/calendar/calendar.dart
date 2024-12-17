import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Gradientowe tło z ciemnym fioletem
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Przezroczysty AppBar
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
        children: const [
          DaySection(day: 'Tommorow', tasks: [
            TaskCard(
              title: 'Name of a task',
              description:
              'This is my short description of task and it would be fun if it is shortened',
              leftColor: Colors.red,
              currentProgress: 3,
              totalProgress: 5,
            ),
          ]),
          DaySection(day: 'Thursday', tasks: [
            TaskCard(
              title: 'Name of a task',
              description:
              'This is my short description of task and it would be fun if it is shortened',
              leftColor: Colors.yellow,
              currentProgress: 1,
              totalProgress: 3,
            ),
          ]),
          DaySection(day: 'Friday', tasks: [
            TaskCard(
              title: 'Name of a task',
              description:
              'This is my short description of task and it would be fun if it is shortened',
              leftColor: Colors.green,
              currentProgress: 1,
              totalProgress: 4,
            ),
          ]),
        ],
      ),
    );
  }
}

class DaySection extends StatelessWidget {
  final String day;
  final List<Widget> tasks;

  const DaySection({
    Key? key,
    required this.day,
    required this.tasks,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Text(
              day,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Maksymalna szerokość dla wszystkich elementów
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500), // Maksymalna szerokość
            child: Column(
              children: tasks,
            ),
          ),
        ],
      ),
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Color leftColor;
  final int currentProgress;
  final int totalProgress;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.leftColor,
    required this.currentProgress,
    required this.totalProgress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE9D5FF), // Jasnofioletowe tło karty
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Lewa sekcja z kolorem
          Container(
            width: 40,
            height: 100,
            decoration: BoxDecoration(
              color: leftColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          // Prawa sekcja z numerami
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: Text(
                    '$currentProgress / $totalProgress',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(Icons.more_vert, color: Colors.black54),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
