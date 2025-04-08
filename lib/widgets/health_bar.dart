import 'package:flutter/material.dart';

class HealthBar extends StatelessWidget {
  final int healthLevel;

  const HealthBar({super.key, required this.healthLevel});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8.0),
          child: Text(
            'Health Status',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        Row(
          children: List.generate(10, (index) {
            Color color;
            if (index < 3) {
              color = Colors.red;
            } else if (index < 7) {
              color = Colors.orange;
            } else {
              color = Colors.green;
            }
            return Expanded(
              child: Container(
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: index < healthLevel ? color : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
