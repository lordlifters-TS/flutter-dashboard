import 'package:flutter/material.dart';

class PatientDetailScreen extends StatelessWidget {
  final String patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patient Details')),
      body: Center(
        child: Text('Patient ID: $patientId'),
      ),
    );
  }
}
