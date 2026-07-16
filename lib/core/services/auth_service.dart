import 'api_client.dart';

/// Models for auth data passed between screens and the state layer.
class WorkerRegistrationData {
  final String phone;
  final String role;
  final String language;
  final String name;
  final int age;
  final String gender;
  final String? aadhaarNumber;
  final String? category;
  final String? primarySkill;
  final String? specialization;
  final String? customSkill;
  final String? customSpecialization;
  final String? experienceLevel;
  final String state;
  final String district;
  final String mandal;
  final String? village;

  const WorkerRegistrationData({
    required this.phone,
    required this.role,
    required this.language,
    required this.name,
    required this.age,
    required this.gender,
    this.aadhaarNumber,
    this.category,
    this.primarySkill,
    this.specialization,
    this.customSkill,
    this.customSpecialization,
    this.experienceLevel,
    required this.state,
    required this.district,
    required this.mandal,
    this.village,
  });
}

class EmployerRegistrationData {
  final String phone;
  final String language;
  final String businessName;
  final String ownerName;
  final int? ownerAge;
  final String? ownerGender;
  final String? email;
  final String businessType;
  final String? customBusinessType;
  final String state;
  final String district;
  final String mandal;
  final String? village;

  const EmployerRegistrationData({
    required this.phone,
    required this.language,
    required this.businessName,
    required this.ownerName,
    this.ownerAge,
    this.ownerGender,
    this.email,
    required this.businessType,
    this.customBusinessType,
    required this.state,
    required this.district,
    required this.mandal,
    this.village,
  });
}

/// Handles all API calls related to authentication.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final _client = ApiClient.instance;

  // ─── Check User ───────────────────────────────────────────────────────────
  Future<ApiResult<Map<String, dynamic>>> checkUser({
    required String phone,
  }) {
    return _client.post('/auth/check-user', {
      'phone': phone,
    });
  }

  // ─── Send OTP ─────────────────────────────────────────────────────────────
  /// Sends a 6-digit OTP to [phone]. Returns success or an error message.
  /// In dev mode the backend also returns devOtp for testing.
  Future<ApiResult<Map<String, dynamic>>> sendOtp({
    required String phone,
    required String role,
    required String language,
  }) {
    return _client.post('/auth/send-otp', {
      'phone': phone,
      'role': role,
      'language': language,
    });
  }

  // ─── Verify OTP ───────────────────────────────────────────────────────────
  /// Verifies the OTP code.
  /// - If existing user → returns { token, isNewUser: false }
  /// - If new user      → returns { isNewUser: true, phone }
  Future<ApiResult<Map<String, dynamic>>> verifyOtp({
    required String phone,
    required String code,
  }) {
    return _client.post('/auth/verify-otp', {
      'phone': phone,
      'code': code,
    });
  }

  // ─── Register Worker ──────────────────────────────────────────────────────
  /// Submits the full worker registration. Returns token + profile summary.
  Future<ApiResult<Map<String, dynamic>>> registerWorker(
      WorkerRegistrationData data) {
    return _client.post('/auth/register/worker', {
      'phone': data.phone,
      'role': data.role,
      'language': data.language,
      'name': data.name,
      'age': data.age,
      'gender': data.gender,
      if (data.aadhaarNumber != null && data.aadhaarNumber!.trim().isNotEmpty)
        'aadhaarNumber': data.aadhaarNumber!.trim(),
      if (data.category != null && data.category!.trim().isNotEmpty)
        'category': data.category!.trim(),
      if (data.primarySkill != null && data.primarySkill!.trim().isNotEmpty)
        'primarySkill': data.primarySkill!.trim(),
      if (data.specialization != null && data.specialization!.trim().isNotEmpty)
        'specialization': data.specialization!.trim(),
      if (data.customSkill != null && data.customSkill!.trim().isNotEmpty)
        'customSkill': data.customSkill!.trim(),
      if (data.customSpecialization != null && data.customSpecialization!.trim().isNotEmpty)
        'customSpecialization': data.customSpecialization!.trim(),
      if (data.experienceLevel != null &&
          const ['No Experience', '1-2 Years', '2-5 Years', '5-10 Years', '10+ Years']
              .contains(data.experienceLevel!.trim()))
        'experienceLevel': data.experienceLevel!.trim(),
      'location': {
        'state': data.state,
        'district': data.district,
        'mandal': data.mandal,
        if (data.village != null && data.village!.isNotEmpty)
          'village': data.village,
      },
    });
  }

  // ─── Register Employer ────────────────────────────────────────────────────
  /// Submits the full employer registration. Returns token + profile summary.
  Future<ApiResult<Map<String, dynamic>>> registerEmployer(
      EmployerRegistrationData data) {
    return _client.post('/auth/register/employer', {
      'phone': data.phone,
      'language': data.language,
      'businessName': data.businessName,
      'ownerName': data.ownerName,
      if (data.ownerAge != null) 'ownerAge': data.ownerAge,
      if (data.ownerGender != null) 'ownerGender': data.ownerGender,
      if (data.email != null && data.email!.trim().isNotEmpty)
        'email': data.email!.trim(),
      'businessType': data.businessType,
      if (data.customBusinessType != null && data.customBusinessType!.trim().isNotEmpty)
        'customBusinessType': data.customBusinessType!.trim(),
      'location': {
        'state': data.state,
        'district': data.district,
        'mandal': data.mandal,
        if (data.village != null && data.village!.isNotEmpty)
          'village': data.village,
      },
    });
  }

  // ─── Get Me ───────────────────────────────────────────────────────────────
  /// Returns the authenticated user and their profile.
  Future<ApiResult<Map<String, dynamic>>> getMe() {
    return _client.get('/auth/me', auth: true);
  }

  // ─── Update Profile ───────────────────────────────────────────────────────
  /// Updates the logged-in user profile (Worker or Employer details).
  Future<ApiResult<Map<String, dynamic>>> updateProfile(Map<String, dynamic> updateData) {
    return _client.put('/users/profile', updateData, auth: true);
  }
  // ─── PIN Authentication ───────────────────────────────────────────────────
  Future<ApiResult<Map<String, dynamic>>> loginWithPin({
    required String phone,
    required String pin,
  }) {
    return _client.post('/auth/login-with-pin', {
      'phone': phone,
      'pin': pin,
    });
  }

  Future<ApiResult<Map<String, dynamic>>> setPin({
    required String pin,
    required String confirmPin,
  }) {
    return _client.post('/auth/set-pin', {
      'pin': pin,
      'confirmPin': confirmPin,
    }, auth: true);
  }

  Future<ApiResult<Map<String, dynamic>>> changePin({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) {
    return _client.post('/auth/change-pin', {
      'currentPin': currentPin,
      'newPin': newPin,
      'confirmPin': confirmPin,
    }, auth: true);
  }
}
