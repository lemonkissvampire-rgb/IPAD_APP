import 'package:flutter/material.dart';
import '../theme/colors.dart';

class CustomTimePicker extends StatelessWidget {
  final Function(String) onTimeSelected;

  const CustomTimePicker({
    super.key,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> times = [];
    for (int h = 8; h <= 20; h++) {
      for (int m = 0; m < 60; m += 15) {
        final period = h >= 12 ? 'PM' : 'AM';
        final displayH = h > 12 ? h - 12 : (h == 0 ? 12 : h);
        final timeStr = "$displayH:${m == 0 ? '00' : m} $period";
        times.add(timeStr);
      }
    }

    return Container(
      width: 200,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
        ],
        border: Border.all(color: AppColors.maroon, width: 1.5),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: const Text(
              'SELECT TIME',
              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: AppColors.maroon),
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.separated(
              itemCount: times.length,
              separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xffEEEEEE)),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () => onTimeSelected(times[index]),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Text(
                        times[index],
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
