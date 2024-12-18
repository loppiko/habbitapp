import 'package:flutter/material.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:provider/provider.dart';


class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Consumer<TodosRepository>(
        builder: (context, repository, child) {
          final todos = repository.todos; // Dostęp do danych repozytorium

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return ListTile(
                title: Text(todo.text),
                subtitle: Text(todo.notes),
              );
            },
          );
        },
      ),
    );
  }


  Map<String, List<Todo>> _groupTodosByDay(List<Todo> todos) {
    final Map<String, List<Todo>> todosByDay = {};

    for (final todo in todos) {
      final dueDate = todo.date ?? todo.creationDate;
      if (dueDate == null) continue;

      final dayKey = "${dueDate.year}-${dueDate.month}-${dueDate.day}";

      if (!todosByDay.containsKey(dayKey)) {
        todosByDay[dayKey] = [];
      }
      todosByDay[dayKey]!.add(todo);
    }

    return todosByDay;
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

