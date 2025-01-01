import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';

class AddDailyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HabiticaColors.purple100, // Tło aplikacji
      body: SafeArea(
        child: Column(
          children: [
            // Górny panel
            UpperPanel(),

            // Środkowy panel
            MiddlePanel(),

            // Dolny panel
            Expanded(child: BottomPanel()),
          ],
        ),
      ),
    );
  }
}

// Upper Panel - Znak wyjścia i przycisk zapisu
class UpperPanel extends StatelessWidget {
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
            onPressed: () {
              // Logika zapisu
            },
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

// Middle Panel - Tytuł i Notatki
class MiddlePanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
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

// Bottom Panel - Repeats every and Difficulty
class BottomPanel extends StatefulWidget {
  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> {
  final TextEditingController _repeatController = TextEditingController();
  String _selectedFrequency = 'Daily';
  final List<String> frequencies = ['Daily', 'Weekly', 'Monthly', 'Yearly'];
  final List<bool> selectedDays = List.generate(7, (_) => false);
  final List<String> days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabiticaColors.purple50, // Nowy kolor tła dla bottom panel
      padding: const EdgeInsets.all(24.0), // Powiększony padding wewnątrz panelu
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Difficulty
            SectionTitle(title: "Difficulty"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DifficultyButton(label: "Trivial", imagePath: 'assets/images/stars/Trivial.png'),
                DifficultyButton(label: "Easy", imagePath: 'assets/images/stars/Easy.png'),
                DifficultyButton(label: "Medium", imagePath: 'assets/images/stars/Medium.png'),
                DifficultyButton(label: "Hard", imagePath: 'assets/images/stars/Hard.png'),
              ],
            ),
            const SizedBox(height: 16),

            // Scheduling
            SectionTitle(title: "Scheduling"),
            ElevatedButton.icon(
              onPressed: () {
                // Wybór daty
              },
              icon: const Icon(Icons.calendar_today, color: Colors.white),
              label: const Text(
                "Start date",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white70),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: HabiticaColors.purple200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(double.infinity, 48), // Zajmuje całą szerokość
              ),
            ),
            const SizedBox(height: 16),

            // Repeats every
            SectionTitle(title: "Repeats every"),
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _repeatController,
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
                    value: _selectedFrequency,
                    dropdownColor: HabiticaColors.purple200,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: HabiticaColors.purple200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                    items: frequencies.map((String frequency) {
                      return DropdownMenuItem<String>(
                        value: frequency,
                        child: Text(frequency),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _selectedFrequency = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Days of the week
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(7, (index) {
                return ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedDays[index] = !selectedDays[index];
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedDays[index]
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
      ),
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

  const DifficultyButton({
    Key? key,
    required this.label,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(imagePath, height: 60),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }
}
