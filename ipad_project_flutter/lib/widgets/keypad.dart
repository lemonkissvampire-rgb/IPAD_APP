import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomKeypad extends StatelessWidget {
  final Function(String) onDigitPressed;
  final VoidCallback onBackspace;

  const CustomKeypad({
    super.key,
    required this.onDigitPressed,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildRow(['1', '2', '3']),
        _buildRow(['4', '5', '6']),
        _buildRow(['7', '8', '9']),
        _buildRow(['', '0', 'delete']),
      ],
    );
  }

  Widget _buildRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: labels.map((label) {
        if (label == '') {
          return const SizedBox(width: 80, height: 80);
        }
        if (label == 'delete') {
          return _buildKey(
            child: const Icon(Icons.backspace_outlined, color: AppColors.maroon, size: 28),
            onPressed: onBackspace,
          );
        }
        return _buildKey(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
            ),
          ),
          onPressed: () => onDigitPressed(label),
        );
      }).toList(),
    );
  }

  Widget _buildKey({required Widget child, required VoidCallback onPressed}) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.all(10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.maroon, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
