import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final String? selectedValue;
  final List<String> items;
  final Function(String) onSelected;
  final bool isRequired;

  const CustomDropdown({
    super.key,
    required this.label,
    this.selectedValue,
    required this.items,
    required this.onSelected,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PopupMenuButton<String>(
            offset: const Offset(0, 48),
            onSelected: onSelected,
            itemBuilder: (context) => items
                .map((item) => PopupMenuItem(
                      value: item,
                      child: Text(
                        item,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.maroon,
                        ),
                      ),
                    ))
                .toList(),
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.maroon, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    selectedValue ?? label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: selectedValue == null ? const Color(0xffCC99A2) : Colors.black,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.maroon,
                  ),
                ],
              ),
            ),
          ),
          if (isRequired)
            const Positioned(
              left: -15,
              top: 5,
              child: Text(
                '*',
                style: TextStyle(
                  color: AppColors.maroon,
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
