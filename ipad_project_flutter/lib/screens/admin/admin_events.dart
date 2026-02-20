import 'package:flutter/material.dart';
import '../../theme/colors.dart';

class AdminEventsScreen extends StatelessWidget {
  final Function(String) onEventSelected;
  final VoidCallback onLogout;

  const AdminEventsScreen({
    super.key,
    required this.onEventSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    // Mock data
    final events = [
      {'name': 'AGRIDOM GRAND OPENING', 'date': '2026-02-15', 'salesperson': 'JUAN DELA CRUZ', 'leads': 45},
      {'name': 'FARMERS EXPO 2026', 'date': '2026-02-18', 'salesperson': 'MARIA CLARA', 'leads': 128},
      {'name': 'SF GROUP TECH SUMMIT', 'date': '2026-02-20', 'salesperson': 'PEDRO PENDUKO', 'leads': 32},
    ];

    return Container(
      color: Colors.white,
      width: double.infinity,
      child: Column(
        children: [
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'ADMIN PORTAL',
                style: Theme.of(context).textTheme.displayLarge?.copyWith(fontSize: 32),
              ),
              const SizedBox(width: 10),
              IconButton(onPressed: onLogout, icon: const Icon(Icons.logout, color: AppColors.maroon)),
            ],
          ),
          const SizedBox(height: 30),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              'SELECT AN EVENT TO MANAGE LEADS',
              style: TextStyle(fontWeight: FontWeight.w800, color: AppColors.maroon, fontSize: 16),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xffEEEEEE)),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(15),
                    title: Text(
                      event['name'] as String,
                      style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.maroon),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        Text('DATE: ${event['date']}'),
                        Text('SALESPERSON: ${event['salesperson']}'),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${event['leads']}',
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.maroon),
                        ),
                        const Text('LEADS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    onTap: () => onEventSelected(event['name'] as String),
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
