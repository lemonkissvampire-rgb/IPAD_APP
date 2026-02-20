import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class WSFinalScreen extends StatelessWidget {
  final VoidCallback onDone;

  const WSFinalScreen({
    super.key,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 100),
          const Icon(Icons.check_circle_outline, size: 120, color: AppColors.successGreen),
          const SizedBox(height: 40),
          const Text(
            'THANK YOU!',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
              letterSpacing: -1.5,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 60),
            child: Text(
              'Your information has been successfully logged. We appreciate your time and feedback!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: AppColors.greyText,
                height: 1.4,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 80),
            child: SizedBox(
              width: double.infinity,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.maroon,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: onDone,
                child: const Text(
                  'FINISH',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
