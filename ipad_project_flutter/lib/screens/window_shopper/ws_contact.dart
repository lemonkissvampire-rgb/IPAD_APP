import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/keypad.dart';

class WSContactScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WSContactScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<WSContactScreen> createState() => _WSContactScreenState();
}

class _WSContactScreenState extends State<WSContactScreen> {
  String phoneNumber = "";

  void _addDigit(String digit) {
    if (phoneNumber.length < 11) {
      setState(() {
        phoneNumber += digit;
      });
    }
  }

  void _removeDigit() {
    if (phoneNumber.isNotEmpty) {
      setState(() {
        phoneNumber = phoneNumber.substring(0, phoneNumber.length - 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Text(
            'BRANDSYNC',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 50),
          const Text(
            'PLEASE ENTER YOUR CONTACT NUMBER',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 30),
          // Phone Display
          Container(
            width: 300,
            height: 60,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.maroon, width: 2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                phoneNumber.isEmpty ? '09XX XXX XXXX' : phoneNumber,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: phoneNumber.isEmpty ? const Color(0xffCC99A2) : AppColors.maroon,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          // Keypad
          CustomKeypad(
            onDigitPressed: _addDigit,
            onBackspace: _removeDigit,
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.maroon, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: widget.onBack,
                      child: const Text('BACK', style: TextStyle(color: AppColors.maroon, fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: SizedBox(
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.maroon,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 0,
                      ),
                      onPressed: phoneNumber.length >= 10 ? widget.onNext : null,
                      child: const Text('PROCEED', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
