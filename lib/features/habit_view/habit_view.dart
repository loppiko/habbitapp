import 'package:flutter/material.dart';
import 'package:habbitapp/features/components/views/upper_panel.dart';
import 'package:habbitapp/shared/tasks/habits/habit_repository.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitRepository = Provider.of<HabitRepository>(context);
    final habits = habitRepository.habits;

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
          SizedBox(height: 20),
          Expanded(
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 500),
                child: HabitList(habits: habits),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HabitList extends StatelessWidget {
  final List habits;

  const HabitList({Key? key, required this.habits}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final habitRepository = Provider.of<HabitRepository>(context, listen: false);

    return ListView.builder(
      itemCount: habits.length,
      itemBuilder: (context, index) {
        final habit = habits[index];
        return Dismissible(
          key: Key(habit.id),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            habitRepository.remove(habit.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Habit deleted")),
            );
          },
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Icon(Icons.delete, color: Colors.white),
          ),
          child: TaskCard(habit: habit),
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final habit;

  const TaskCard({Key? key, required this.habit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            Container(
              width: 60,
              decoration: BoxDecoration(
                color: habit.leftTaskColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  topLeft: Radius.circular(20),
                ),
              ),
              child: Center(
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: habit.leftCircleColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
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
                      habit.text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      habit.notes,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Text(
                  "+${habit.counterUp}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Text(
                  "-${habit.counterDown}",
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  decoration: BoxDecoration(
                    color: habit.rightTaskColor,
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: habit.rightCircleColor,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.remove, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
