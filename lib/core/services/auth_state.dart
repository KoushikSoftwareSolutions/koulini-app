import 'package:flutter/foundation.dart';
import 'api_client.dart';
import 'auth_service.dart';

/// Holds the runtime auth state of the app.
/// Provided to the widget tree via [ChangeNotifierProvider].
class AuthState extends ChangeNotifier {
  // ─── State fields ──────────────────────────────────────────────────────────
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  /// Authenticated user's ID, role, and profile (from GET /me).
  String? userId;
  String? role;
  String? language;
  bool isRegistered = false;
  Map<String, dynamic>? profile;

  Map<String, dynamic>? stats;
  List<dynamic>? workHistory;

  // ─── Temporary fields shared across the multi-screen registration flow ────
  /// Saved after OTP is verified (new user).
  String? pendingPhone;

  /// Saved after WorkerRegistrationScreen (name, age, gender, etc).
  String? pendingName;
  int? pendingAge;
  String? pendingGender;
  String? pendingAadhaar;

  /// Saved after SkillSelectionScreen.
  String? pendingSkill;
  String? pendingCustomSkill;
  String? pendingExperienceLevel;

  /// Saved in EmployerRegistrationScreen.
  String? pendingBusinessName;
  String? pendingOwnerName;
  int? pendingOwnerAge;
  String? pendingOwnerGender;
  String? pendingEmail;
  String? pendingBusinessType;
  String? pendingCustomBusinessType;

  // ─── Public getters ────────────────────────────────────────────────────────
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // ─── Private helpers ───────────────────────────────────────────────────────
  void _setLoading(bool v) {
    _isLoading = v;
    notifyListeners();
  }

  void _setError(String? msg) {
    _error = msg;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void _applyToken(Map<String, dynamic> data) {
    final token = data['token'] as String?;
    if (token != null) {
      ApiClient.instance.saveToken(token);
    }
    userId = data['data']?['userId'] as String?;
    role = data['data']?['role'] as String?;
    isRegistered = data['data']?['isRegistered'] as bool? ?? false;
    profile = data['data']?['profile'] as Map<String, dynamic>?;
    stats = data['data']?['stats'] as Map<String, dynamic>?;
    workHistory = data['data']?['workHistory'] as List<dynamic>?;
    _isLoggedIn = true;
  }

  // ─── Try to restore session on app start ──────────────────────────────────
  Future<void> tryRestoreSession() async {
    final token = await ApiClient.instance.getToken();
    if (token == null) return;

    _setLoading(true);
    final result = await AuthService.instance.getMe();
    _setLoading(false);

    if (result.success && result.data != null) {
      final d = result.data!['data'] as Map<String, dynamic>?;
      if (d != null) {
        userId = d['userId'] as String?;
        role = d['role'] as String?;
        language = d['language'] as String?;
        isRegistered = d['isRegistered'] as bool? ?? false;
        profile = d['profile'] as Map<String, dynamic>?;
        stats = d['stats'] as Map<String, dynamic>?;
        workHistory = d['workHistory'] as List<dynamic>?;
        _isLoggedIn = true;
        notifyListeners();
      }
    } else {
      // ONLY clear the token if the error is an explicit authentication error (e.g. invalid/expired token),
      // NOT a temporary network offline or server connection issue.
      final err = result.error ?? '';
      final isNetworkError = err.contains('connection') || 
                            err.contains('internet') || 
                            err.contains('reach the server') ||
                            err.contains('SocketException') ||
                            err.contains('PlatformException') ||
                            err.contains('channel-error') ||
                            err.contains('Unexpected response');
      if (!isNetworkError) {
        await ApiClient.instance.clearToken();
      }
    }
  }

  // ─── Verify OTP ───────────────────────────────────────────────────────────
  /// Returns true if the OTP was valid. Caller should check [isRegistered]
  /// to decide whether to go to the home screen or the registration flow.
  Future<bool> verifyOtp({
    required String phone,
    required String code,
  }) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthService.instance.verifyOtp(phone: phone, code: code);

    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    final isNewUser = result.data?['isNewUser'] as bool? ?? false;
    if (isNewUser) {
      // Save phone for the subsequent registration call
      pendingPhone = result.data?['phone'] as String? ?? phone;
      notifyListeners();
      return true;
    }

    // Existing user — token is in the response
    _applyToken(result.data!);
    notifyListeners();
    return true;
  }

  // ─── Register Worker ──────────────────────────────────────────────────────
  Future<bool> registerWorker({
    required String state,
    required String district,
    required String mandal,
    String? village,
  }) async {
    _setLoading(true);
    _setError(null);

    final data = WorkerRegistrationData(
      phone: pendingPhone!,
      role: role ?? 'Worker',
      language: language ?? 'en',
      name: pendingName!,
      age: pendingAge!,
      gender: pendingGender!,
      aadhaarNumber: pendingAadhaar,
      primarySkill: pendingSkill,
      customSkill: pendingCustomSkill,
      experienceLevel: pendingExperienceLevel,
      state: state,
      district: district,
      mandal: mandal,
      village: village,
    );

    final result = await AuthService.instance.registerWorker(data);
    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    _applyToken(result.data!);
    _clearPendingWorkerData();
    notifyListeners();
    return true;
  }

  // ─── Register Employer ────────────────────────────────────────────────────
  Future<bool> registerEmployer({
    required String state,
    required String district,
    required String mandal,
    String? village,
  }) async {
    _setLoading(true);
    _setError(null);

    final data = EmployerRegistrationData(
      phone: pendingPhone!,
      language: language ?? 'en',
      businessName: pendingBusinessName!,
      ownerName: pendingOwnerName!,
      ownerAge: pendingOwnerAge,
      ownerGender: pendingOwnerGender,
      email: pendingEmail,
      businessType: pendingBusinessType!,
      customBusinessType: pendingCustomBusinessType,
      state: state,
      district: district,
      mandal: mandal,
      village: village,
    );

    final result = await AuthService.instance.registerEmployer(data);
    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    _applyToken(result.data!);
    _clearPendingEmployerData();
    notifyListeners();
    return true;
  }

  // ─── Update Profile ───────────────────────────────────────────────────────
  Future<bool> updateProfile(Map<String, dynamic> updateData) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthService.instance.updateProfile(updateData);
    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    profile = result.data?['data'] as Map<String, dynamic>?;
    notifyListeners();
    return true;
  }

  // ─── Sign out ─────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await ApiClient.instance.clearToken();
    _isLoggedIn = false;
    userId = null;
    role = null;
    language = null;
    isRegistered = false;
    profile = null;
    stats = null;
    workHistory = null;
    pendingPhone = null;
    notifyListeners();
  }

  // ─── Internal cleanup ─────────────────────────────────────────────────────
  void _clearPendingWorkerData() {
    pendingPhone = null;
    pendingName = null;
    pendingAge = null;
    pendingGender = null;
    pendingAadhaar = null;
    pendingSkill = null;
    pendingCustomSkill = null;
    pendingExperienceLevel = null;
  }

  void _clearPendingEmployerData() {
    pendingPhone = null;
    pendingBusinessName = null;
    pendingOwnerName = null;
    pendingOwnerAge = null;
    pendingOwnerGender = null;
    pendingEmail = null;
    pendingBusinessType = null;
    pendingCustomBusinessType = null;
  }
}
