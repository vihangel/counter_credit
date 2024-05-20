import 'package:flutter/material.dart';

class IconTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String text;
  const IconTextButton(
      {super.key,
      required this.onPressed,
      required this.icon,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Card.outlined(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon),
              const SizedBox(width: 16),
              Text(text),
            ],
          ),
        ),
      ),
    );
  }
}
