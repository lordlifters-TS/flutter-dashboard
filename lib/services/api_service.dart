import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Change this to your Laravel backend URL
  static const String baseUrl = 'http://localhost:8000/api';

  final _storage = const FlutterSecureStorage();
  late Dio _dio;

  void init() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
    ));

    _dio.interceptors.addAll([
      PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true),
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'access_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            // Token expired - try refresh
            try {
              final refreshed = await _refreshToken();
              if (refreshed) {
                final token = await _storage.read(key: 'access_token');
                error.requestOptions.headers['Authorization'] = 'Bearer $token';
                final response = await _dio.fetch(error.requestOptions);
                handler.resolve(response);
                return;
              }
            } catch (_) {}
            await _storage.deleteAll();
          }
          handler.next(error);
        },
      ),
    ]);
  }

  Future<bool> _refreshToken() async {
    try {
      final response = await _dio.post('/auth/refresh');
      await _storage.write(key: 'access_token', value: response.data['access_token']);
      return true;
    } catch (_) {
      return false;
    }
  }

  // Auth
  Future<Map<String, dynamic>> login(String email, String password) async {
    final res = await _dio.post('/auth/login', data: {'email': email, 'password': password});
    await _storage.write(key: 'access_token', value: res.data['access_token']);
    return res.data;
  }

  Future<void> logout() async {
    try { await _dio.post('/auth/logout'); } catch (_) {}
    await _storage.deleteAll();
  }

  Future<Map<String, dynamic>> getMe() async {
    final res = await _dio.get('/auth/me');
    return res.data['data'];
  }

  // Dashboard
  Future<Map<String, dynamic>> getDashboardStats() async {
    final res = await _dio.get('/dashboard/stats');
    return res.data['data'];
  }

  // Patients
  Future<Map<String, dynamic>> getPatients({String? search, int page = 1}) async {
    final res = await _dio.get('/patients', queryParameters: {
      'search': search, 'page': page, 'per_page': 15,
    });
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getPatient(String id) async {
    final res = await _dio.get('/patients/$id');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> createPatient(Map<String, dynamic> data) async {
    final res = await _dio.post('/patients', data: data);
    return res.data['data'];
  }

  Future<Map<String, dynamic>> updatePatient(String id, Map<String, dynamic> data) async {
    final res = await _dio.put('/patients/$id', data: data);
    return res.data['data'];
  }

  // Health Records
  Future<Map<String, dynamic>> getHealthRecords({String? patientId, int page = 1}) async {
    final res = await _dio.get('/health-records', queryParameters: {
      'patient_id': patientId, 'page': page,
    });
    return res.data['data'];
  }

  Future<Map<String, dynamic>> createHealthRecord(Map<String, dynamic> data) async {
    final res = await _dio.post('/health-records', data: data);
    return res.data['data'];
  }

  Future<Map<String, dynamic>> addPrescription(String recordId, Map<String, dynamic> data) async {
    final res = await _dio.post('/health-records/$recordId/prescriptions', data: data);
    return res.data['data'];
  }

  Future<Map<String, dynamic>> addLabRequest(String recordId, Map<String, dynamic> data) async {
    final res = await _dio.post('/health-records/$recordId/lab-requests', data: data);
    return res.data['data'];
  }

  // Referrals
  Future<Map<String, dynamic>> getReferrals({String? status, String? direction, int page = 1}) async {
    final res = await _dio.get('/referrals', queryParameters: {
      'status': status, 'direction': direction, 'page': page,
    });
    return res.data['data'];
  }

  Future<Map<String, dynamic>> getReferral(String id) async {
    final res = await _dio.get('/referrals/$id');
    return res.data['data'];
  }

  Future<Map<String, dynamic>> createReferral(Map<String, dynamic> data) async {
    final res = await _dio.post('/referrals', data: data);
    return res.data['data'];
  }

  Future<void> acceptReferral(String id) async {
    await _dio.post('/referrals/$id/accept');
  }

  Future<void> rejectReferral(String id, String reason) async {
    await _dio.post('/referrals/$id/reject', data: {'rejection_reason': reason});
  }

  Future<void> completeReferral(String id, {String? feedback}) async {
    await _dio.post('/referrals/$id/complete', data: {'feedback': feedback});
  }

  Future<Map<String, dynamic>> getReferralStats() async {
    final res = await _dio.get('/referrals/statistics');
    return res.data['data'];
  }

  // Facilities
  Future<Map<String, dynamic>> getFacilities({String? search}) async {
    final res = await _dio.get('/facilities', queryParameters: {'search': search});
    return res.data['data'];
  }

  // Notifications
  Future<Map<String, dynamic>> getNotifications() async {
    final res = await _dio.get('/users/me/notifications');
    return res.data['data'];
  }

  Future<void> markNotificationRead(String id) async {
    await _dio.post('/users/me/notifications/$id/read');
  }

  Future<bool> isLoggedIn() async {
    return await _storage.read(key: 'access_token') != null;
  }
}
