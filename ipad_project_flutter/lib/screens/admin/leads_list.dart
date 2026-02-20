import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class LeadsListScreen extends StatelessWidget {
  final String eventName;
  final VoidCallback onBack;

  const LeadsListScreen({
    super.key,
    required this.eventName,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data
    final leads = [
      {'phone': '09123456789', 'email': 'john@example.com', 'exp': 'EXCELLENT', 'int': 'OUTSTANDING'},
      {'phone': '09223334444', 'email': 'mary@test.org', 'exp': 'GOOD', 'int': 'GOOD'},
      {'phone': '09998887777', 'email': 'dave@corp.com', 'exp': 'FAIR', 'int': 'EXCELLENT'},
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(onPressed: onBack, icon: const Icon(Icons.arrow_back, color: AppColors.maroon)),
                Expanded(
                  child: Text(
                    eventName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.maroon),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Header Row
          Container(
            color: AppColors.maroon,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: const Row(
              children: [
                Expanded(flex: 3, child: Text('CONTACT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 2, child: Text('EXP', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
                Expanded(flex: 2, child: Text('INT', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: leads.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final lead = leads[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(lead['phone']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                            Text(lead['email']!, style: const TextStyle(fontSize: 10, color: AppColors.greyText)),
                          ],
                        ),
                      ),
                      Expanded(flex: 2, child: Text(lead['exp']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                      Expanded(flex: 2, child: Text(lead['int']!, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.successGreen),
                onPressed: () {},
                icon: const Icon(Icons.download, color: Colors.white),
                label: const Text('EXPORT TO EXCEL', style: TextStyle(fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
