import 'package:flutter/foundation.dart';

class Patient {
  final String id;
  final String name;
  final String age;
  final String gender;
  final String phone;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.phone,
  });
}

class PatientProvider extends ChangeNotifier {
  bool isLoading = false;
  bool hasMore = true;
  List<Patient> patients = [];

  Future<void> loadPatients({bool refresh = false, String? search}) async {
    if (refresh) patients = [];
    isLoading = true;
    notifyListeners();

    // TODO: Replace with your real API call
    await Future.delayed(const Duration(seconds: 1));

    patients = [
      Patient(id: '1', name: 'John Doe', age: '34', gender: 'Male', phone: '0712345678'),
      Patient(id: '2', name: 'Jane Smith', age: '28', gender: 'Female', phone: '0723456789'),
      Patient(id: '3', name: 'Ali Hassan', age: '45', gender: 'Male', phone: '0734567890'),
    ];

    if (search != null && search.isNotEmpty) {
      patients = patients
          .where((p) => p.name.toLowerCase().contains(search.toLowerCase()))
          .toList();
    }

    hasMore = false;
    isLoading = false;
    notifyListeners();
  }
}
