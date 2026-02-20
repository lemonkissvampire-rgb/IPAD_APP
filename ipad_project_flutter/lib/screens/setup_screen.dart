import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/colors.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../widgets/custom_calendar_picker.dart';
import '../widgets/custom_time_picker.dart';

class SetupScreen extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback onStart;

  const SetupScreen({
    super.key,
    required this.onBack,
    required this.onStart,
  });

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  bool isMultiCompany = false;
  bool isLongEvent = false;
  String? selectedMainCompany;
  DateTime selectedDate = DateTime.now();
  String? timeStarted;
  String? timeEnded;
  
  bool showCalendar = false;
  bool showTimeStart = false;
  bool showTimeEnd = false;

  final List<String> companies = [
    'SF Group of Companies, Inc.',
    'Agridom Solutions Corp.',
    'Aerobot Distribution Inc.',
    'DJAS Servitrade Corporation',
    'Agridom Academy',
    'Sunfood Marketing Inc.',
    'Ardent Services Corporation',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.5), // Modal overlay
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 520,
              height: 700,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.only(top: 30, right: 40, left: 40),
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              const Text(
                                'WELCOME',
                                style: TextStyle(
                                  color: AppColors.maroon,
                                  fontSize: 32,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Lorem ipsum dolor sit amet consectetur adipiscing elit. Sit amet consectetur adipiscing elit quisque faucibus es sapien vitae pellentesque.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.greyText,
                                  height: 1.4,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: -20,
                          top: -10,
                          child: IconButton(
                            icon: const Icon(Icons.close, size: 28, color: Color(0xff999999)),
                            onPressed: widget.onBack,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Form
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CustomTextField(
                              placeholder: 'NAME OF SALESPERSON WHO CONDUCTED THIS:',
                              isRequired: true,
                            ),
                            const CustomTextField(
                              placeholder: 'EVENT NAME / TITLE OF THE EVENT:',
                              isRequired: true,
                            ),
                            const CustomTextField(
                              placeholder: 'ADRESS OF THE EVENT:',
                              isRequired: true,
                            ),
                            
                            // Company Section
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomDropdown(
                                    label: 'COMPANY:',
                                    selectedValue: selectedMainCompany,
                                    items: companies,
                                    onSelected: (val) => setState(() => selectedMainCompany = val),
                                    isRequired: true,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Text('MULTI-COMPANY?', style: TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w800, fontSize: 12)),
                                        const SizedBox(width: 5),
                                        SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: Checkbox(
                                            value: isMultiCompany,
                                            onChanged: (val) => setState(() => isMultiCompany = val!),
                                          ),
                                        ),
                                        const SizedBox(width: 5),
                                        const CircleAvatar(
                                          radius: 9,
                                          backgroundColor: Color(0xffcccccc),
                                          child: Text('?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            
                            // Date & Time
                            Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: CustomTextField(
                                    placeholder: 'DATE OF THE EVENT:',
                                    isRequired: true,
                                    readOnly: true,
                                    controller: TextEditingController(text: DateFormat('yyyy-MM-dd').format(selectedDate)),
                                    onTap: () => setState(() => showCalendar = !showCalendar),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    height: 45,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: AppColors.maroon, width: 1.5),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => showTimeStart = !showTimeStart),
                                            child: Center(
                                              child: Text(
                                                timeStarted ?? 'TIME STARTED',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: timeStarted == null ? const Color(0xffCC99A2) : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Container(width: 1.5, height: 25, color: AppColors.maroon.withOpacity(0.3)),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => setState(() => showTimeEnd = !showTimeEnd),
                                            child: Center(
                                              child: Text(
                                                timeEnded ?? 'TIME ENDED',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: timeEnded == null ? const Color(0xffCC99A2) : Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            Row(
                              children: [
                                const Text('LONG EVENT?', style: TextStyle(color: AppColors.maroon, fontWeight: FontWeight.w800, fontSize: 12)),
                                const SizedBox(width: 8),
                                SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: Checkbox(
                                    value: isLongEvent,
                                    onChanged: (val) => setState(() => isLongEvent = val!),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                const CircleAvatar(
                                  radius: 9,
                                  backgroundColor: Color(0xffcccccc),
                                  child: Text('?', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Footer
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                    child: SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                          elevation: 0,
                        ),
                        onPressed: widget.onStart,
                        child: const Text('START', style: TextStyle(fontSize: 22, letterSpacing: 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Floating Pickers
            if (showCalendar)
              Positioned(
                top: 350,
                left: 100,
                child: CustomCalendarPicker(
                  initialDate: selectedDate,
                  onDateSelected: (date) {
                    setState(() {
                      selectedDate = date;
                      showCalendar = false;
                    });
                  },
                ),
              ),
            if (showTimeStart)
              Positioned(
                top: 350,
                right: 90,
                child: CustomTimePicker(
                  onTimeSelected: (time) {
                    setState(() {
                      timeStarted = time;
                      showTimeStart = false;
                    });
                  },
                ),
              ),
            if (showTimeEnd)
              Positioned(
                top: 350,
                right: 40,
                child: CustomTimePicker(
                  onTimeSelected: (time) {
                    setState(() {
                      timeEnded = time;
                      showTimeEnd = false;
                    });
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
