import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/shared/tasks/dailys/daily.dart'; // Repozytorium Daily
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart'; // Model Daily
import 'package:habbitapp/features/components/views/upper_panel.dart';

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
                width: 500,
                child: DailyList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DailyList extends StatelessWidget {
  const DailyList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyRepository = Provider.of<DailyRepository>(context);
    final dailys = dailyRepository.getAll();

    if (dailys.isEmpty) {
      return const Center(child: Text('No tasks available'));
    }

    final sortedDailys = [...dailys];
    sortedDailys.sort((a, b) {
      if (a.nextDueInDays() == -1 && b.nextDueInDays() == -1) return 0;
      if (a.nextDueInDays() == -1) return -1;
      if (b.nextDueInDays() == -1) return 1;
      return a.nextDueInDays().compareTo(b.nextDueInDays());
    });

    String? previousDateLabel;

    return ListView.builder(
      itemCount: sortedDailys.length,
      itemBuilder: (context, index) {
        final daily = sortedDailys[index];
        final currentDateLabel = daily.nextDueInText();
        final showDateLabel =
            currentDateLabel.isNotEmpty && currentDateLabel != previousDateLabel;

        if (showDateLabel) {
          previousDateLabel = currentDateLabel;
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showDateLabel)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Divider(
                        color: HabiticaColors.purple50,
                        thickness: 1.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        currentDateLabel,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: HabiticaColors.gray700,
                        ),
                      ),
                    ),
                    const Expanded(
                      child: Divider(
                        color: HabiticaColors.purple50,
                        thickness: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            Dismissible(
              key: Key(daily.id),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                dailyRepository.remove(daily.id);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Deleted ${daily.text}")),
                );
              },
              background: Container(
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                color: Colors.red,
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: TaskItem(daily: daily),
            ),
          ],
        );
      },
    );
  }
}

class TaskItem extends StatelessWidget {
  final Daily daily;

  const TaskItem({Key? key, required this.daily}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dailyRepository = Provider.of<DailyRepository>(context, listen: false);

    Future<void> _scoreDaily() async {
      final result = await dailyRepository.scoreDaily(context, daily.id);
      final double moneyDiff = result['moneyDiff']!;
      final double expDiff = result['expDiff']!;

      String notification = 'Daily scored:';
      if (moneyDiff != 0) {
        notification += '+${moneyDiff.toStringAsFixed(2)} Gold';
      }
      if (expDiff != 0) {
        notification += '+${expDiff.toStringAsFixed(0)} XP';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(notification)));
    }

    return Card(
      color: const Color(0xFFE9D5FF),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MouseRegion(
              cursor: daily.completed ? SystemMouseCursors.basic : SystemMouseCursors.click,
              child: GestureDetector(
                onTap: daily.completed ? null : _scoreDaily,
                child: Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: daily.taskColor,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      topLeft: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          color: daily.circleColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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
