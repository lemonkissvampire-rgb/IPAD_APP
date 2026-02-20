import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';

class CustomCalendarPicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomCalendarPicker({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<CustomCalendarPicker> createState() => _CustomCalendarPickerState();
}

class _CustomCalendarPickerState extends State<CustomCalendarPicker> {
  late DateTime _currentMonth;

  @override
  void initState() {
    super.initState();
    _currentMonth = DateTime(widget.initialDate.year, widget.initialDate.month);
  }

  void _changeMonth(int delta) {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + delta);
    });
  }

  @override
  Widget build(BuildContext context) {
    final monthName = DateFormat('MMMM yyyy').format(_currentMonth).toUpperCase();
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstDayOfWeek = DateTime(_currentMonth.year, _currentMonth.month, 1).weekday % 7;
    final prevMonthDays = DateTime(_currentMonth.year, _currentMonth.month, 0).day;

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 15, offset: const Offset(0, 5))
        ],
        border: Border.all(color: AppColors.maroon, width: 1.5),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Text('<', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.maroon)),
                  onPressed: () => _changeMonth(-1),
                ),
                Text(
                  monthName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.maroon),
                ),
                IconButton(
                  icon: const Text('>', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.maroon)),
                  onPressed: () => _changeMonth(1),
                ),
              ],
            ),
          ),
          // Weekdays
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['SUN', 'MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT']
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600, color: AppColors.greyText)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 5),
          // Days Grid
          Padding(
            padding: const EdgeInsets.all(10),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
              ),
              itemCount: 42, // 6 rows
              itemBuilder: (context, index) {
                if (index < firstDayOfWeek) {
                  // Prev month
                  return Center(
                    child: Text(
                      '${prevMonthDays - firstDayOfWeek + index + 1}',
                      style: const TextStyle(color: Color(0xffcccccc), fontSize: 11),
                    ),
                  );
                }
                final dayNum = index - firstDayOfWeek + 1;
                if (dayNum > daysInMonth) {
                  // Next month (simplified)
                  return Center(
                    child: Text(
                      '${dayNum - daysInMonth}',
                      style: const TextStyle(color: Color(0xffcccccc), fontSize: 11),
                    ),
                  );
                }
                
                final isToday = dayNum == DateTime.now().day &&
                    _currentMonth.month == DateTime.now().month &&
                    _currentMonth.year == DateTime.now().year;

                return GestureDetector(
                  onTap: () => widget.onDateSelected(DateTime(_currentMonth.year, _currentMonth.month, dayNum)),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isToday ? AppColors.maroon : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: Text(
                        '$dayNum',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: isToday ? Colors.white : Colors.black,
                        ),
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
