import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';


class MiddleAddPanel extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController notesController;

  const MiddleAddPanel({
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
