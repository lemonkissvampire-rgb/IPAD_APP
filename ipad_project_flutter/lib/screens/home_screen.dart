import 'package:flutter/material.dart';
import '../theme/colors.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onCreateNew;
  final VoidCallback onAdminAccess;
  final VoidCallback onOpenEvent;

  const HomeScreen({
    super.key,
    required this.onCreateNew,
    required this.onAdminAccess,
    required this.onOpenEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            // Maroon Bar
            Container(
              width: 80,
              height: 15,
              color: AppColors.maroon,
            ),
            const SizedBox(height: 10),
            // Brand Title
            Text(
              'BRANDSYNC',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 52,
                    letterSpacing: -1,
                    height: 1,
                  ),
            ),
            const SizedBox(height: 5),
            // Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.maroon,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'DATA COLLECTION',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(height: 25),
            // Description
            const Text(
              'Designed to streamline lead generation, this app digitizes the entire data-capture process, allowing teams to collect information faster, minimize manual work, and improve overall efficiency.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 25),
            // Action Section
            Column(
              children: [
                _buildActionButton(
                  text: 'CREATE NEW',
                  color: AppColors.maroon,
                  textColor: Colors.white,
                  onPressed: onCreateNew,
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 60,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.maroon),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'OPEN EVENT',
                              style: TextStyle(
                                color: AppColors.maroon,
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: AppColors.maroon),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 100,
                      height: 60,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.maroon,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: onOpenEvent,
                        child: const Text('OPEN', style: TextStyle(fontSize: 20)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Divider
                Stack(
                  alignment: Alignment.center,
                  children: [
                    const Divider(color: Color(0xffDDDDDD)),
                    Container(
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: const Text(
                        'OR',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.greyText,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildActionButton(
                  text: 'ADMIN ACCESS',
                  color: AppColors.yellow,
                  textColor: AppColors.maroon,
                  onPressed: onAdminAccess,
                ),
              ],
            ),
            const SizedBox(height: 25),
            // Admin Description
            const Text(
              'Admin Access provides centralized control where all event-generated leads are stored, reviewed, and managed. Use this section to view, track, and organize leads from every event in one secure location.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.greyText,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 40),
            // Footer
            const Text(
              'Powered by: Marketing & CSE Department © 2026 BrandSync',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.greyText,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required Color color,
    required Color textColor,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          elevation: 0,
        ),
        onPressed: onPressed,
        child: Text(text),
      ),
    );
  }
}
