import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class WSLandingScreen extends StatelessWidget {
  final VoidCallback onBegin;
  final VoidCallback onExit;

  const WSLandingScreen({
    super.key,
    required this.onBegin,
    required this.onExit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Logo placeholder or text
          Text(
            'BRANDSYNC',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 40),
          ),
          const SizedBox(height: 100),
          const Text(
            'WINDOW SHOPPER',
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
              'Follow the quick steps on the screen to provide your information and share your feedback.',
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
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 100,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.maroon,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: onBegin,
                    child: const Text(
                      'START THE LOG',
                      style: TextStyle(fontSize: 28, letterSpacing: 1),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: onExit,
                  child: const Text(
                    'EXIT TO HOME',
                    style: TextStyle(color: Color(0xff999999), fontWeight: FontWeight.bold),
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
