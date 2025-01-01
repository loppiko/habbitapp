import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';

class AddHabitScreen extends StatelessWidget {
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

// Bottom Panel - Checklist, Difficulty i Scheduling
class BottomPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: HabiticaColors.purple50, // Nowy kolor tła dla bottom panel
      padding: const EdgeInsets.all(24.0), // Powiększony padding wewnątrz panelu
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Positive i Negative przyciski
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logika dla Positive
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HabiticaColors.purple200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(120, 48),
                  ),
                  child: const Text(
                      "Positive",
                      style: TextStyle(color: Colors.white70)
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Logika dla Negative
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HabiticaColors.purple200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(120, 48),
                  ),
                  child: const Text(
                      "Negative",
                      style: TextStyle(color: Colors.white70)
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

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
            const SizedBox(height: 24),

            // Reset Counter
            SectionTitle(title: "Reset Counter"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Logika dla Daily
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HabiticaColors.purple200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(100, 48),
                  ),
                  child: const Text(
                      "Daily",
                      style: TextStyle(color: Colors.white70)
                  )
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logika dla Weekly
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HabiticaColors.purple200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(100, 48),
                  ),
                    child: const Text(
                        "Weekly",
                        style: TextStyle(color: Colors.white70)
                    )
                ),
                ElevatedButton(
                  onPressed: () {
                    // Logika dla Monthly
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HabiticaColors.purple200,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: Size(100, 48),
                  ),
                    child: const Text(
                        "Monthly",
                        style: TextStyle(color: Colors.white70)
                    )
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// Pomocniczy widget tytułu sekcji
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

// Przycisk trudności z obrazkami
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