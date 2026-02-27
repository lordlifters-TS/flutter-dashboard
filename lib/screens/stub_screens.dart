// =============================================
// STUB SCREENS - Full implementation required
// =============================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/sidebar_widget.dart';

// patient_detail_screen.dart
class PatientDetailScreen extends StatelessWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/patients'),
        Expanded(child: Scaffold(
          appBar: AppBar(
            title: Text('Patient #$patientId'),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/patients')),
          ),
          body: const Center(child: Text('Patient Detail Screen - Implement full patient profile here')),
        )),
      ]),
    );
  }
}

// add_patient_screen.dart
class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/patients'),
        Expanded(child: Scaffold(
          appBar: AppBar(
            title: const Text('Register New Patient'),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/patients')),
          ),
          body: const Center(child: Text('Add Patient Form - Implement full patient registration form here')),
        )),
      ]),
    );
  }
}

// referral_detail_screen.dart
class ReferralDetailScreen extends StatelessWidget {
  final String referralId;
  const ReferralDetailScreen({super.key, required this.referralId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/referrals'),
        Expanded(child: Scaffold(
          appBar: AppBar(
            title: Text('Referral #$referralId'),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/referrals')),
          ),
          body: const Center(child: Text('Referral Detail - Accept/Reject/Complete actions + shared documents')),
        )),
      ]),
    );
  }
}

// create_referral_screen.dart
class CreateReferralScreen extends StatelessWidget {
  const CreateReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/referrals'),
        Expanded(child: Scaffold(
          appBar: AppBar(
            title: const Text('Create Referral'),
            leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => context.go('/referrals')),
          ),
          body: const Center(child: Text('Create Referral Form - Select patient, facility, add clinical summary')),
        )),
      ]),
    );
  }
}

// health_records_screen.dart
class HealthRecordsScreen extends StatelessWidget {
  const HealthRecordsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/health-records'),
        Expanded(child: Scaffold(
          appBar: AppBar(title: const Text('Health Records')),
          body: const Center(child: Text('Health Records Screen - List all visits with vitals and diagnosis')),
        )),
      ]),
    );
  }
}

// add_health_record_screen.dart
class AddHealthRecordScreen extends StatelessWidget {
  const AddHealthRecordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/health-records'),
        Expanded(child: Scaffold(
          appBar: AppBar(title: const Text('New Health Record')),
          body: const Center(child: Text('Add Health Record Form - Vitals, Diagnosis, Treatment Plan')),
        )),
      ]),
    );
  }
}

// facilities_screen.dart
class FacilitiesScreen extends StatelessWidget {
  const FacilitiesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/facilities'),
        Expanded(child: Scaffold(
          appBar: AppBar(title: const Text('Health Facilities')),
          body: const Center(child: Text('Facilities Screen - Map and list view of all health facilities')),
        )),
      ]),
    );
  }
}

// notifications_screen.dart
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(children: [
        const SidebarWidget(currentRoute: '/notifications'),
        Expanded(child: Scaffold(
          appBar: AppBar(title: const Text('Notifications')),
          body: const Center(child: Text('Notifications Screen - Referral updates, patient alerts')),
        )),
      ]),
    );
  }
}
