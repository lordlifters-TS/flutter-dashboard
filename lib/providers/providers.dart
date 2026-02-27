import 'package:flutter/material.dart';
import '../services/api_service.dart';

// ===================== Dashboard Provider =====================
class DashboardProvider extends ChangeNotifier {
  final _api = ApiService();

  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _stats = await _api.getDashboardStats();
    } catch (e) {
      _error = 'Failed to load dashboard data';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}

// ===================== Patient Provider =====================
class PatientProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _patients = [];
  Map<String, dynamic>? _selectedPatient;
  bool _isLoading = false;
  String? _error;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _searchQuery;

  List<dynamic> get patients => _patients;
  Map<String, dynamic>? get selectedPatient => _selectedPatient;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadPatients({String? search, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _patients = [];
      _hasMore = true;
    }
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    _searchQuery = search;
    notifyListeners();

    try {
      final data = await _api.getPatients(search: search, page: _currentPage);
      final newPatients = data['data'] as List;
      _patients.addAll(newPatients);
      _hasMore = data['current_page'] < data['last_page'];
      _currentPage++;
    } catch (e) {
      _error = 'Failed to load patients';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadPatient(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedPatient = await _api.getPatient(id);
    } catch (e) {
      _error = 'Failed to load patient';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createPatient(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final patient = await _api.createPatient(data);
      _patients.insert(0, patient);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearSelection() {
    _selectedPatient = null;
    notifyListeners();
  }
}

// ===================== Referral Provider =====================
class ReferralProvider extends ChangeNotifier {
  final _api = ApiService();

  List<dynamic> _referrals = [];
  Map<String, dynamic>? _selectedReferral;
  Map<String, dynamic>? _stats;
  bool _isLoading = false;
  String? _error;
  String? _filterStatus;
  String? _filterDirection;

  List<dynamic> get referrals => _referrals;
  Map<String, dynamic>? get selectedReferral => _selectedReferral;
  Map<String, dynamic>? get stats => _stats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadReferrals({String? status, String? direction}) async {
    _isLoading = true;
    _filterStatus = status;
    _filterDirection = direction;
    notifyListeners();
    try {
      final data = await _api.getReferrals(status: status, direction: direction);
      _referrals = data['data'] as List;
    } catch (e) {
      _error = 'Failed to load referrals';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadReferral(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      _selectedReferral = await _api.getReferral(id);
    } catch (e) {
      _error = 'Failed to load referral';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadStats() async {
    try {
      _stats = await _api.getReferralStats();
      notifyListeners();
    } catch (_) {}
  }

  Future<bool> createReferral(Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final referral = await _api.createReferral(data);
      _referrals.insert(0, referral);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> acceptReferral(String id) async {
    await _api.acceptReferral(id);
    await loadReferral(id);
  }

  Future<void> rejectReferral(String id, String reason) async {
    await _api.rejectReferral(id, reason);
    await loadReferral(id);
  }

  Future<void> completeReferral(String id, {String? feedback}) async {
    await _api.completeReferral(id, feedback: feedback);
    await loadReferral(id);
  }
}
