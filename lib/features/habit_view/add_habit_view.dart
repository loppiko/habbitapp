import 'package:flutter/material.dart';
import 'package:habbitapp/features/components/add_views/difficulty_add_button.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';
import 'package:habbitapp/shared/tasks/habits/habit_repository.dart';
import 'package:provider/provider.dart';
import 'package:habbitapp/features/components/add_views/upper_add_panel.dart';
import 'package:habbitapp/features/components/add_views/middle_add_panel.dart';
import 'package:habbitapp/features/components/add_views/section_add_title.dart';


class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}


class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedDifficulty = "Easy";
  bool isPositive = false;
  bool isNegative = false;
  String selectedReset = "daily";

  void handleSave(BuildContext context) {
    final String title = titleController.text.trim();

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

    final newHabit = Habit(
      text: title,
      notes: notesController.text.trim(),
      priority: priority,
      up: isPositive,
      down: isNegative,
      frequency: selectedReset,
    );

    final habitRepository = Provider.of<HabitRepository>(context, listen: false);
    habitRepository.append(newHabit);

    Navigator.of(context).pop();
  }

  void onDifficultySelected(String difficulty) {
    setState(() {
      selectedDifficulty = difficulty;
    });
  }

  void onResetSelected(String reset) {
    setState(() {
      selectedReset = reset;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabiticaColors.purple100,
      body: SafeArea(
        child: Column(
          children: [
            UpperAddPanel(onSave: () => handleSave(context)),
            MiddleAddPanel(
              titleController: titleController,
              notesController: notesController,
            ),
            Expanded(
              child: BottomPanel(
                  selectedDifficulty: selectedDifficulty,
                  onDifficultySelected: onDifficultySelected,
                  isPositive: isPositive,
                  isNegative: isNegative,
                  onPositiveToggle: () {
                    setState(() {
                      isPositive = !isPositive;
                    });
                  },
                  onNegativeToggle: () {
                    setState(() {
                      isNegative = !isNegative;
                    });
                  },
                  selectedReset: selectedReset,
                  onResetSelected: onResetSelected
              ),
            )
          ],
        ),
      ),
    );
  }
}


class BottomPanel extends StatelessWidget {
  final String? selectedDifficulty;
  final Function(String) onDifficultySelected;
  final bool isPositive;
  final bool isNegative;
  final VoidCallback onPositiveToggle;
  final VoidCallback onNegativeToggle;
  final String? selectedReset;
  final Function(String) onResetSelected;


  BottomPanel({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
    required this.isPositive,
    required this.isNegative,
    required this.onPositiveToggle,
    required this.onNegativeToggle,
    required this.selectedReset,
    required this.onResetSelected
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceButton(
                  label: "Positive",
                  isSelected: isPositive,
                  onTap: onPositiveToggle,
                ),
                ChoiceButton(
                  label: "Negative",
                  isSelected: isNegative,
                  onTap: onNegativeToggle,
                ),
              ],
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
            SectionTitle(title: "Reset Counter"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceButton(
                  label: "Daily",
                  isSelected: selectedReset == "daily",
                  onTap: () => onResetSelected("daily"),
                ),
                ChoiceButton(
                  label: "Weekly",
                  isSelected: selectedReset == "weekly",
                  onTap: () => onResetSelected("weekly"),
                ),
                ChoiceButton(
                  label: "Monthly",
                  isSelected: selectedReset == "monthly",
                  onTap: () => onResetSelected("monthly"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}


class ChoiceButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const ChoiceButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? HabiticaColors.purple200 : HabiticaColors.purple200.withValues(alpha: 0.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        minimumSize: const Size(100, 48),
      ),
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}