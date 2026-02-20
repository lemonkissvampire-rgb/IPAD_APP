import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme/colors.dart';
import 'screens/home_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/window_shopper/ws_landing.dart';
import 'screens/window_shopper/ws_contact.dart';
import 'screens/window_shopper/ws_email.dart';
import 'screens/window_shopper/ws_survey.dart';
import 'screens/window_shopper/ws_final.dart';
import 'screens/admin/admin_login.dart';
import 'screens/admin/admin_events.dart';
import 'screens/admin/leads_list.dart';

void main() {
  runApp(const BrandSyncApp());
}

class BrandSyncApp extends StatelessWidget {
  const BrandSyncApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BrandSync',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.maroon,
          primary: AppColors.maroon,
          secondary: AppColors.yellow,
          background: AppColors.white,
        ),
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).copyWith(
          displayLarge: GoogleFonts.inter(
            fontWeight: FontWeight.w900,
            color: AppColors.maroon,
          ),
          displayMedium: GoogleFonts.outfit(
            fontWeight: FontWeight.w900,
            color: AppColors.maroon,
          ),
          bodyLarge: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 16,
          ),
          bodyMedium: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 14,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.maroon,
            foregroundColor: AppColors.white,
            textStyle: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            ),
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
      home: const MainScreenSwitcher(),
    );
  }
}

class MainScreenSwitcher extends StatefulWidget {
  const MainScreenSwitcher({super.key});

  @override
  State<MainScreenSwitcher> createState() => _MainScreenSwitcherState();
}

class _MainScreenSwitcherState extends State<MainScreenSwitcher> {
  String _currentScreenId = 'screen-home';
  bool _showSetupModal = false;
  String _selectedEventName = '';

  void showScreen(String screenId) {
    setState(() {
      _currentScreenId = screenId;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600, maxHeight: 800),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              _buildCurrentScreen(),
              if (_showSetupModal)
                SetupScreen(
                  onBack: () => setState(() => _showSetupModal = false),
                  onStart: () {
                    setState(() {
                      _showSetupModal = false;
                      _currentScreenId = 'screen-ws-landing';
                    });
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreenId) {
      case 'screen-home':
        return HomeScreen(
          onCreateNew: () => setState(() => _showSetupModal = true),
          onAdminAccess: () => showScreen('screen-admin-login'),
          onOpenEvent: () {
            // In the real app, this would open a selector
            setState(() => _showSetupModal = true);
          },
        );
      
      // Window Shopper Flow
      case 'screen-ws-landing':
        return WSLandingScreen(
          onBegin: () => showScreen('screen-ws-contact'),
          onExit: () => showScreen('screen-home'),
        );
      case 'screen-ws-contact':
        return WSContactScreen(
          onNext: () => showScreen('screen-ws-email'),
          onBack: () => showScreen('screen-ws-landing'),
        );
      case 'screen-ws-email':
        return WSEmailScreen(
          onNext: () => showScreen('screen-ws-survey'),
          onBack: () => showScreen('screen-ws-contact'),
        );
      case 'screen-ws-survey':
        return WSSurveyScreen(
          onNext: () => showScreen('screen-ws-final'),
          onBack: () => showScreen('screen-ws-email'),
        );
      case 'screen-ws-final':
        return WSFinalScreen(
          onDone: () => showScreen('screen-ws-landing'),
        );

      // Admin Flow
      case 'screen-admin-login':
        return AdminLoginScreen(
          onLoginSuccess: () => showScreen('screen-admin-events'),
          onBack: () => showScreen('screen-home'),
        );
      case 'screen-admin-events':
        return AdminEventsScreen(
          onEventSelected: (name) {
            setState(() {
              _selectedEventName = name;
              _currentScreenId = 'screen-leads-list';
            });
          },
          onLogout: () => showScreen('screen-home'),
        );
      case 'screen-leads-list':
        return LeadsListScreen(
          eventName: _selectedEventName,
          onBack: () => showScreen('screen-admin-events'),
        );

      default:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Screen $_currentScreenId not implemented'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => showScreen('screen-home'),
                child: const Text('BACK TO HOME'),
              ),
            ],
          ),
        );
    }
  }
}
