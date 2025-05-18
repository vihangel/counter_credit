import 'package:flutter/material.dart';

class ProductListTileButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String name;
  final String description;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ProductListTileButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.name,
    required this.description,
    required this.onDelete,
    required this.onEdit,
  });

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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      name,
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      description,
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEdit,
              ),
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
