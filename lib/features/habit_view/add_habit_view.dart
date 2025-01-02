import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/shared/tasks/habits/habit.dart';
import 'package:habbitapp/shared/tasks/habits/habit_repository.dart';
import 'package:provider/provider.dart';

class AddHabitScreen extends StatefulWidget {
  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}


class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  String? selectedDifficulty = "Easy"; // Default value
  bool isPositive = false;
  bool isNegative = false;
  String selectedReset = "daily"; // Default reset option

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
            UpperPanel(onSave: () => handleSave(context)),
            MiddlePanel(
              titleController: titleController,
              notesController: notesController,
            ),
            PositiveNegativeButtons(
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
            ),
            DifficultyButtons(
              selectedDifficulty: selectedDifficulty,
              onDifficultySelected: onDifficultySelected,
            ),
            ResetCounterButtons(
              selectedReset: selectedReset,
              onResetSelected: onResetSelected,
            ),
          ],
        ),
      ),
    );
  }
}

class UpperPanel extends StatelessWidget {
  final VoidCallback onSave;

  const UpperPanel({required this.onSave});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            onPressed: onSave,
            child: const Text(
              'Save',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MiddlePanel extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController notesController;

  const MiddlePanel({
    required this.titleController,
    required this.notesController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Title",
              filled: true,
              fillColor: HabiticaColors.purple50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: "Notes",
              filled: true,
              fillColor: HabiticaColors.purple50,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelStyle: TextStyle(color: Colors.white70),
            ),
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class PositiveNegativeButtons extends StatelessWidget {
  final bool isPositive;
  final bool isNegative;
  final VoidCallback onPositiveToggle;
  final VoidCallback onNegativeToggle;

  const PositiveNegativeButtons({
    required this.isPositive,
    required this.isNegative,
    required this.onPositiveToggle,
    required this.onNegativeToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
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
    );
  }
}

class DifficultyButtons extends StatelessWidget {
  final String? selectedDifficulty;
  final Function(String) onDifficultySelected;

  const DifficultyButtons({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 12),
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
      ],
    );
  }
}

class ResetCounterButtons extends StatelessWidget {
  final String? selectedReset;
  final Function(String) onResetSelected;

  const ResetCounterButtons({
    required this.selectedReset,
    required this.onResetSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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


class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class DifficultyButton extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback onSelect;

  const DifficultyButton({
    Key? key,
    required this.label,
    required this.imagePath,
    required this.isSelected,
    required this.onSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onSelect,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isSelected ? HabiticaColors.purple200 : Colors.transparent,
          ),
          child: Column(
            children: [
              Image.asset(imagePath, height: 60),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


