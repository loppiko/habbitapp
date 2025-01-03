import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';
import 'package:habbitapp/features/components/add_views/upper_add_panel.dart';
import 'package:habbitapp/features/components/add_views/middle_add_panel.dart';
import 'package:habbitapp/shared/tasks/dailys/daily.dart';
import 'package:habbitapp/shared/tasks/dailys/daily_repository.dart';
import 'package:habbitapp/features/components/add_views/section_add_title.dart';
import 'package:habbitapp/features/components/add_views/difficulty_add_button.dart';
import 'package:provider/provider.dart';


class AddDailyScreen extends StatefulWidget {
  @override
  _AddDailyScreenState createState() => _AddDailyScreenState();
}


class _AddDailyScreenState extends State<AddDailyScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  final TextEditingController frequencyController = TextEditingController();

  String? selectedDifficulty = "Easy";
  DateTime? selectedDate;
  int everyX = 1;
  String selectedFrequency = "Weekly";

  Map<String, bool> repeat = {
    "m": false,
    "t": false,
    "w": false,
    "th": false,
    "f": false,
    "s": false,
    "su": false,
  };

  void handleDailySave(BuildContext context) async {
    final String title = titleController.text.trim();
    final String notes = notesController.text.trim();
    final String frequencyText = frequencyController.text.trim();

    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Title is required!')),
      );
      return;
    }

    if (frequencyText.isNotEmpty) {
      try {
        final parsedValue = int.parse(frequencyText);
        if (parsedValue >= 1 && parsedValue <= 365) {
          everyX = parsedValue;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Frequency must be between 1 and 365')),
          );
          return;
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid frequency. Please enter a number.')),
        );
        return;
      }
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

    print('Title: $title');
    print('Notes: $notes');
    print('Priority: $priority');
    print('Start Date: $selectedDate');
    print('Repeat: $repeat');
    print('Frequency: $selectedFrequency');
    print('Every X: $everyX');

    final newDaily = Daily(
      text: title,
      notes: notes,
      priority: priority,
      startDate: selectedDate,
      repeat: repeat,
      frequency: selectedFrequency.toLowerCase(),
      everyX: everyX,
    );

    final dailyRepository = Provider.of<DailyRepository>(context, listen: false);
    await dailyRepository.append(newDaily);

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

  void _toggleRepeat(String day) {
    setState(() {
      repeat[day] = !(repeat[day] ?? false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabiticaColors.purple100,
      body: SafeArea(
        child: Column(
          children: [
            UpperAddPanel(onSave: () => handleDailySave(context)),
            MiddleAddPanel(titleController: titleController, notesController: notesController),
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
                repeat: repeat,
                onToggleRepeat: _toggleRepeat,
                frequencyController: frequencyController,
                onFrequencyChanged: (value) {
                  everyX = int.tryParse(value) ?? 1;
                },
                selectedFrequency: selectedFrequency,
                onToggleRepeatEnabled: (value) {
                  setState(() {
                    selectedFrequency = value;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// Bottom Panel - Repeats every and Difficulty

class BottomPanel extends StatelessWidget {
  final String? selectedDifficulty;
  final Function(String) onDifficultySelected;
  final VoidCallback onDateSelected;
  final DateTime? selectedDate;
  final Map<String, bool> repeat;
  final Function(String) onToggleRepeat;
  final TextEditingController frequencyController;
  final Function(String) onFrequencyChanged;
  final String selectedFrequency;
  final Function(String) onToggleRepeatEnabled;

  BottomPanel({
    required this.selectedDifficulty,
    required this.onDifficultySelected,
    required this.onDateSelected,
    required this.selectedDate,
    required this.repeat,
    required this.onToggleRepeat,
    required this.frequencyController,
    required this.onFrequencyChanged,
    required this.selectedFrequency,
    required this.onToggleRepeatEnabled,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> days = ["M", "T", "W", "Th", "F", "S", "Su"];

    return Container(
      padding: const EdgeInsets.all(16.0),
      color: HabiticaColors.purple50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
                  : "Start date",
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

          SectionTitle(title: "Repeats every"),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: frequencyController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HabiticaColors.purple200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    labelText: 'Enter number',
                    labelStyle: TextStyle(color: Colors.white70),
                  ),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                flex: 3,
                child: DropdownButtonFormField<String>(
                  value: selectedFrequency, // Use selectedFrequency
                  dropdownColor: HabiticaColors.purple200,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: HabiticaColors.purple200,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  items: const ["Daily", "Weekly", "Monthly", "Yearly"].map((String frequency) {
                    return DropdownMenuItem<String>(
                      value: frequency,
                      child: Text(frequency, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (String? value) {
                    if (value != null) {
                      onFrequencyChanged(value);
                    }
                  },
                ),
              )
            ],
          ),
          const SizedBox(height: 16),

          SectionTitle(title: "Days of the week"),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              return ElevatedButton(
                onPressed: () {
                  onToggleRepeat(days[index].toLowerCase());
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: repeat[days[index].toLowerCase()] == true
                      ? HabiticaColors.purple300
                      : HabiticaColors.purple200,
                  shape: CircleBorder(),
                  padding: EdgeInsets.all(16),
                ),
                child: Text(
                  days[index],
                  style: TextStyle(color: Colors.white),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

