import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';

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
          final todos = repository.todos; // Pobranie zadań z repozytorium

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo = todos[index];
              return Center(
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
                  ),
                ),
              );
            },
          );
        },
      ),
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
  final int priority;

  const TaskCard({
    Key? key,
    required this.title,
    required this.description,
    required this.leftColor,
    required this.circleColor,
    required this.currentProgress,
    required this.totalProgress,
    required this.priority,
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
          // Lewa sekcja z kolorem i kółkiem
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
          // Środkowa sekcja z tytułem i opisem
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
          // Prawa sekcja z postępem i kropkami
          Container(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Postęp w zadaniu
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
                // Kropki odpowiadające priorytetowi
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    priority,
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
