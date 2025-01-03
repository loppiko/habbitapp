import 'package:flutter/material.dart';
import 'package:habbitapp/features/components/add_views/difficulty_add_button.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/todos/todo.dart';
import 'package:habbitapp/shared/tasks/todos/todo_repository.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/features/components/add_views/upper_add_panel.dart';
import 'package:habbitapp/features/components/add_views/middle_add_panel.dart';
import 'package:habbitapp/features/components/add_views/section_add_title.dart';


class AddTodoScreen extends StatefulWidget {
  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedDifficulty = "Easy";
  DateTime? selectedDate;

  void handleTodoSave(BuildContext context) async {
    final String title = titleController.text.trim();
    final String notes = notesController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title is required!')),
      );
      return;
    }

    double priority = 1.0;
    switch (selectedDifficulty) {
      case "Trivial":
        priority = 0.1;
        break;
      case "Easy":
        priority = 1.0;
        break;
      case "Medium":
        priority = 1.5;
        break;
      case "Hard":
        priority = 2.0;
        break;
    }

    final newTodo = Todo(
      text: title,
      notes: notes.isNotEmpty ? notes : "",
      priority: priority,
      date: selectedDate,
    );

    final todosRepository = Provider.of<TodosRepository>(context, listen: false);
    await todosRepository.append(newTodo);

    Navigator.of(context).pop();
  }

  void _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabiticaColors.purple100,
      body: SafeArea(
        child: Column(
          children: [
            UpperAddPanel(
              onSave: () => handleTodoSave(context),
            ),
            MiddleAddPanel(
              titleController: titleController,
              notesController: notesController,
            ),
            Expanded(
              child: BottomPanel(
                selectedDifficulty: selectedDifficulty,
                onDifficultySelected: (difficulty) {
                  setState(() {
                    selectedDifficulty = difficulty;
                  });
                },
                onDateSelected: () => _selectDate(context),
                selectedDate: selectedDate,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class BottomPanel extends StatelessWidget {
  final String? selectedDifficulty;
  final Function(String) onDifficultySelected;
  final VoidCallback onDateSelected;
  final DateTime? selectedDate;

  BottomPanel({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
    required this.onDateSelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabiticaColors.purple50,
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title: "Checklist"),
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: Colors.white),
              label: const Text(
                "New entry",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white70),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HabiticaColors.purple200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
            ),
            const SizedBox(height: 16),

            SectionTitle(title: "Difficulty"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DifficultyButton(
                  label: "Trivial",
                  imagePath: 'assets/images/stars/Trivial.png',
                  isSelected: selectedDifficulty == "Trivial",
                  onSelect: () => onDifficultySelected("Trivial"),
                ),
                DifficultyButton(
                  label: "Easy",
                  imagePath: 'assets/images/stars/Easy.png',
                  isSelected: selectedDifficulty == "Easy",
                  onSelect: () => onDifficultySelected("Easy"),
                ),
                DifficultyButton(
                  label: "Medium",
                  imagePath: 'assets/images/stars/Medium.png',
                  isSelected: selectedDifficulty == "Medium",
                  onSelect: () => onDifficultySelected("Medium"),
                ),
                DifficultyButton(
                  label: "Hard",
                  imagePath: 'assets/images/stars/Hard.png',
                  isSelected: selectedDifficulty == "Hard",
                  onSelect: () => onDifficultySelected("Hard"),
                ),
              ],
            ),
            const SizedBox(height: 16),

            SectionTitle(title: "Scheduling"),
            ElevatedButton.icon(
              onPressed: onDateSelected,
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: Text(
                  selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "Due date",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white70),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HabiticaColors.purple200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 48),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
