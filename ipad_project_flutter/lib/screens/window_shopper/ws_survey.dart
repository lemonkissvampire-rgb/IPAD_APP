import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class WSSurveyScreen extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onBack;

  const WSSurveyScreen({
    super.key,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<WSSurveyScreen> createState() => _WSSurveyScreenState();
}

class _WSSurveyScreenState extends State<WSSurveyScreen> {
  String? experienceRating;
  String? interestRating;
  
  final List<String> ratings = ['POOR', 'FAIR', 'GOOD', 'EXCELLENT', 'OUTSTANDING'];

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
          const SizedBox(height: 40),
          const Text(
            'QUICK FEEDBACK',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: AppColors.maroon,
            ),
          ),
          const SizedBox(height: 30),
          _buildSurveyQuestion(
            'HOW WAS YOUR EXPERIENCE TODAY?',
            experienceRating,
            (val) => setState(() => experienceRating = val),
          ),
          const SizedBox(height: 30),
          _buildSurveyQuestion(
            'HOW INTERESTED ARE YOU IN OUR PRODUCTS?',
            interestRating,
            (val) => setState(() => interestRating = val),
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
                      onPressed: (experienceRating != null && interestRating != null) ? widget.onNext : null,
                      child: const Text('SUBMIT', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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

  Widget _buildSurveyQuestion(String question, String? selected, Function(String) onSelect) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            question,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.maroon),
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: ratings.map((r) {
              final isSelected = selected == r;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ChoiceChip(
                  label: Text(r, style: TextStyle(fontSize: 10, color: isSelected ? Colors.white : AppColors.maroon, fontWeight: FontWeight.bold)),
                  selected: isSelected,
                  onSelected: (s) => onSelect(r),
                  selectedColor: AppColors.maroon,
                  backgroundColor: Colors.white,
                  side: const BorderSide(color: AppColors.maroon),
                  showCheckmark: false,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
