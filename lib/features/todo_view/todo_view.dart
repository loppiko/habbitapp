import 'package:flutter/material.dart';
import 'package:habbitapp/shared/user_data/UserProvider.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/features/components/views/upper_panel.dart';

class CalendarScreen extends StatelessWidget {
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
          Expanded(
            child: TodoList(),
          ),
        ],
      ),
    );
  }
}

class TodoList extends StatelessWidget {
  Future<void> scoreTodo(BuildContext context, String todoId) async {
    final repository = Provider.of<TodosRepository>(context, listen: false);
    final result = await repository.scoreTodo(context, todoId);

    final double moneyDiff = result['moneyDiff']!;
    final double expDiff = result['expDiff']!;

    String notification = 'Todo scored:';
    if (moneyDiff != 0) {
      notification += '+${moneyDiff.toStringAsFixed(2)} Gold';
    }
    if (expDiff != 0) {
      notification += '+${expDiff.toStringAsFixed(0)} XP';
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(notification)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TodosRepository>(
      builder: (context, repository, child) {
        final todos = repository.todos;

        final sortedTodos = [...todos];
        sortedTodos.sort((a, b) {
          if (a.date == null && b.date == null) return 0;
          if (a.date == null) return -1;
          if (b.date == null) return 1;
          return a.date!.compareTo(b.date!);
        });

        String? previousDateLabel;

        return ListView.builder(
          itemCount: sortedTodos.length,
          itemBuilder: (context, index) {
            final todo = sortedTodos[index];
            final currentDateLabel = todo.getNameOfDate();

            final showDateLabel = currentDateLabel.isNotEmpty &&
                currentDateLabel != previousDateLabel;

            if (showDateLabel) {
              previousDateLabel = currentDateLabel;
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (showDateLabel)
                  Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Padding(
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
                                textAlign: TextAlign.center,
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
                    ),
                  ),
                Dismissible(
                  key: Key(todo.id),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    repository.remove(todo.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Deleted ${todo.text}")),
                    );
                  },
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20.0),
                    margin: const EdgeInsets.only(top: 8, bottom: 8, right: 16),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: TaskCard(
                        title: todo.text,
                        description: todo.notes,
                        leftColor: todo.taskColor,
                        circleColor: todo.circleColor,
                        currentProgress: todo.getDoneNumberOfChecklistSubTasks(),
                        totalProgress: todo.getTotalNumberOfChecklistSubTasks(),
                        priority: todo.priority,
                        onLeftTap: () => scoreTodo(context, todo.id),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final Color leftColor;
  final Color circleColor;
  final int currentProgress;
  final int totalProgress;
  final double priority;
  final VoidCallback onLeftTap;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.leftColor,
    required this.circleColor,
    required this.currentProgress,
    required this.totalProgress,
    required this.priority,
    required this.onLeftTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFFE9D5FF),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: onLeftTap,
              child: Container(
                width: 40,
                height: 100,
                decoration: BoxDecoration(
                  color: leftColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: circleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
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
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    (priority * 2).round(),
                        (index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      child: Icon(Icons.circle, size: 8, color: Colors.black54),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
