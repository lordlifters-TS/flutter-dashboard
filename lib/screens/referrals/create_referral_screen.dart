import 'package:flutter/material.dart';

class CreateReferralScreen extends StatelessWidget {
  const CreateReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Referral')),
      body: const Center(
        child: Text('Create Referral Form'),
      ),
    );
  }
}
