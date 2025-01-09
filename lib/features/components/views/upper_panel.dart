import 'package:flutter/material.dart';
import 'package:habbitapp/shared/consts/habitica_colors.dart';


class UpperPanel extends StatelessWidget {
  final String title;
  final VoidCallback onIconPressed;

  const UpperPanel({
    Key? key,
    required this.title,
    required this.onIconPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 12),
                  Text(
                    title,
                    style: const TextStyle(
                      color: HabiticaColors.gray700,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: onIconPressed,
                    icon: const Icon(
                      Icons.calendar_month_outlined,
                      color: HabiticaColors.gray700,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}