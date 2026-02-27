import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'providers/auth_provider.dart';
import 'providers/patient_provider.dart';
import 'providers/referral_provider.dart';
import 'providers/dashboard_provider.dart';
import 'screens/auth/login_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/patients/patients_screen.dart';
import 'screens/patients/patient_detail_screen.dart';
import 'screens/patients/add_patient_screen.dart';
import 'screens/referrals/referrals_screen.dart';
import 'screens/referrals/referral_detail_screen.dart';
import 'screens/referrals/create_referral_screen.dart';
import 'screens/health_records/health_records_screen.dart';
import 'screens/health_records/add_health_record_screen.dart';
import 'screens/facilities/facilities_screen.dart';
import 'screens/notifications/notifications_screen.dart';
import 'utils/app_theme.dart';
import 'screens/patients/patients_screen.dart';
import 'screens/referrals/referrals_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const AfyalinkApp());
}

class AfyalinkApp extends StatelessWidget {
  const AfyalinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PatientProvider()),
        ChangeNotifierProvider(create: (_) => ReferralProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, auth, _) {
          return MaterialApp.router(
            title: 'AFYALINK',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            routerConfig: _buildRouter(auth),
          );
        },
      ),
    );
  }

  GoRouter _buildRouter(AuthProvider auth) {
    return GoRouter(
      initialLocation: '/login',
      redirect: (context, state) {
        final isLoggedIn = auth.isAuthenticated;
        final isLoginRoute = state.matchedLocation == '/login';
        if (!isLoggedIn && !isLoginRoute) return '/login';
        if (isLoggedIn && isLoginRoute) return '/dashboard';
        return null;
      },
      routes: [
        GoRoute(path: '/login',     builder: (c, s) => LoginScreen()),
        GoRoute(path: '/dashboard', builder: (c, s) => DashboardScreen()),
        GoRoute(path: '/patients',  builder: (c, s) => PatientsScreen()),
        GoRoute(
          path: '/patients/:id',
          builder: (c, s) => PatientDetailScreen(patientId: s.pathParameters['id']!),
        ),
        GoRoute(path: '/patients/add',       builder: (c, s) => AddPatientScreen()),
        GoRoute(path: '/referrals',          builder: (c, s) => ReferralsScreen()),
        GoRoute(
          path: '/referrals/:id',
          builder: (c, s) => ReferralDetailScreen(referralId: s.pathParameters['id']!),
        ),
        GoRoute(path: '/referrals/create',   builder: (c, s) => CreateReferralScreen()),
        GoRoute(path: '/health-records',     builder: (c, s) => HealthRecordsScreen()),
        GoRoute(path: '/health-records/add', builder: (c, s) => AddHealthRecordScreen()),
        GoRoute(path: '/facilities',         builder: (c, s) => FacilitiesScreen()),
        GoRoute(path: '/notifications',      builder: (c, s) => NotificationsScreen()),
      ],
    );
  }
}