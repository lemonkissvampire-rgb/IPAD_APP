import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/keypad.dart';

class AdminLoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;
  final VoidCallback onBack;

  const AdminLoginScreen({
    super.key,
    required this.onLoginSuccess,
    required this.onBack,
  });

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  String pin = "";

  void _addDigit(String digit) {
    if (pin.length < 6) {
      setState(() {
        pin += digit;
      });
      if (pin == "1234") { // Mock PIN
        widget.onLoginSuccess();
      }
    }
  }

  void _removeDigit() {
    if (pin.isNotEmpty) {
      setState(() {
        pin = pin.substring(0, pin.length - 1);
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
            'ADMIN PORTAL ACCESS',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'PLEASE ENTER YOUR PIN TO CONTINUE',
            style: TextStyle(color: AppColors.greyText, fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 30),
          // PIN Display
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) {
              return Container(
                width: 20,
                height: 20,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index < pin.length ? AppColors.maroon : Colors.white,
                  border: Border.all(color: AppColors.maroon, width: 2),
                ),
              );
            }),
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
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.maroon, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: widget.onBack,
                child: const Text('BACK TO HOME', style: TextStyle(color: AppColors.maroon, fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
