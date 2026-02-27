import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../utils/app_theme.dart';

class ReferralDetailScreen extends StatelessWidget {
  final String referralId;
  const ReferralDetailScreen({super.key, required this.referralId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Referral #$referralId'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/referrals'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Referral Details',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 24),
                _detailRow('Referral ID', referralId),
                _detailRow('Status', 'Pending'),
                _detailRow('Priority', 'Routine'),
                _detailRow('Patient', 'Loading...'),
                _detailRow('From Facility', 'Loading...'),
                _detailRow('To Facility', 'Loading...'),
                _detailRow('Date', 'Loading...'),
                const SizedBox(height: 32),
                Row(
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Accept'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.successGreen),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 12),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.close, color: AppTheme.errorRed),
                      label: const Text('Reject',
                          style: TextStyle(color: AppTheme.errorRed)),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 140,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.grey)),
          ),
          Text(value, style: const TextStyle(fontSize: 15)),
        ],
      ),
    );
  }
}