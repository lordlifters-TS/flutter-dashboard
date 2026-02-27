import 'package:flutter/foundation.dart';

class DashboardProvider extends ChangeNotifier {
  bool isLoading = false;
  Map<String, dynamic>? stats;

  Future<void> loadStats() async {
    isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    stats = {
      'total_patients': 120,
      'today_visits': 14,
      'pending_referrals': 12,
      'incoming_referrals': 5,
      'monthly_patients': [
        {'month': 1, 'total': 20},
        {'month': 2, 'total': 35},
        {'month': 3, 'total': 28},
        {'month': 4, 'total': 45},
        {'month': 5, 'total': 38},
        {'month': 6, 'total': 52},
      ],
      'referral_stats': {
        'pending': 12,
        'accepted': 8,
        'completed': 30,
        'rejected': 3,
        'arrived': 5,
      },
      'recent_referrals': [
        {
          'referral_number': 'REF-001',
          'patient': {'first_name': 'John', 'last_name': 'Doe'},
          'receiving_facility': {'name': 'Kenyatta Hospital'},
          'priority': 'urgent',
          'status': 'pending',
        },
        {
          'referral_number': 'REF-002',
          'patient': {'first_name': 'Jane', 'last_name': 'Smith'},
          'receiving_facility': {'name': 'Nairobi Hospital'},
          'priority': 'routine',
          'status': 'completed',
        },
      ],
    };

    isLoading = false;
    notifyListeners();
  }
}