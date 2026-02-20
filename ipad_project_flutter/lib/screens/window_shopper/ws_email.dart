import 'package:flutter/material.dart';
import '../../theme/colors.dart';
import '../../widgets/custom_text_field.dart';

class WSEmailScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WSEmailScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

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
            'WE’D LOVE TO HEAR FROM YOU!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'Please provide your email address to stay updated on our latest products and offers.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: AppColors.greyText, height: 1.4),
            ),
          ),
          const SizedBox(height: 40),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: CustomTextField(
              placeholder: 'ENTER YOUR EMAIL ADDRESS',
              isRequired: false,
            ),
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
                      onPressed: onBack,
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
                      onPressed: onNext,
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
