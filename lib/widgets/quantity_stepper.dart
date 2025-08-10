import 'package:flutter/material.dart';

class QuantityStepper extends StatelessWidget {
  final int value;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantityStepper({
    super.key,
    required this.value,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove)),
        Text('$value'),
        IconButton(onPressed: onIncrement, icon: const Icon(Icons.add)),
      ],
    );
  }
}
