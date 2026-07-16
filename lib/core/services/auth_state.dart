import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import 'auth_service.dart';

import '../enums/user_role.dart';

class AuthState extends ChangeNotifier {
  // ─── State fields ──────────────────────────────────────────────────────────
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  /// Authenticated user's ID, role, and profile (from GET /me).
  String? userId;
  String? phone;
  String? role;
  String? language;
  bool isRegistered = false;
  bool hasPin = false;
  Map<String, dynamic>? profile;

  Map<String, dynamic>? stats;
  List<dynamic>? workHistory;

  // ─── Temporary fields shared across the multi-screen registration flow ────
  /// Saved chosen role before OTP verification.
  UserRole? pendingRole;

  /// Saved after OTP is verified (new user).
  String? pendingPhone;

  /// Saved after WorkerRegistrationScreen (name, age, gender, etc).
  String? pendingName;
  int? pendingAge;
  String? pendingGender;
  String? pendingAadhaar;
  String? pendingAadhaarPhoto;

  /// Saved after SkillSelectionScreen.
  String? pendingCategory;
  String? pendingSkill; // Role
  String? pendingSpecialization;
  String? pendingCustomSkill;
  String? pendingCustomSpecialization;
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
    phone = data['data']?['phone'] as String?;
    role = data['data']?['role'] as String?;
    isRegistered = data['data']?['isRegistered'] as bool? ?? false;
    hasPin = data['data']?['hasPin'] as bool? ?? false;
    profile = data['data']?['profile'] as Map<String, dynamic>?;
    stats = data['data']?['stats'] as Map<String, dynamic>?;
    workHistory = data['data']?['workHistory'] as List<dynamic>?;
    _isLoggedIn = true;
  }

  Future<void> setLanguage(String langCode) async {
    language = langCode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_language', langCode);
  }

  Future<void> setPendingRole(UserRole role) async {
    pendingRole = role;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pending_role', role.value);
  }

  // ─── Try to restore session on app start ──────────────────────────────────
  Future<void> tryRestoreSession() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('selected_language') ?? 'en';
    final savedRole = prefs.getString('pending_role');
    if (savedRole != null) {
      pendingRole = UserRoleExtension.fromString(savedRole);
    }

    final token = await ApiClient.instance.getToken();
    if (token == null) {
      notifyListeners();
      return;
    }

    _setLoading(true);
    final result = await AuthService.instance.getMe();
    _setLoading(false);

    if (result.success && result.data != null) {
      final d = result.data!['data'] as Map<String, dynamic>?;
      if (d != null) {
        userId = d['userId'] as String?;
        phone = d['phone'] as String?;
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

  // ─── PIN Authentication ───────────────────────────────────────────────────
  Future<bool> loginWithPin({
    required String phone,
    required String pin,
  }) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthService.instance.loginWithPin(phone: phone, pin: pin);

    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    _applyToken(result.data!);
    hasPin = true; // logged in with PIN, so they definitely have one
    notifyListeners();
    return true;
  }

  Future<bool> setPin({
    required String pin,
    required String confirmPin,
  }) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthService.instance.setPin(pin: pin, confirmPin: confirmPin);

    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

    hasPin = true;
    notifyListeners();
    return true;
  }

  Future<bool> changePin({
    required String currentPin,
    required String newPin,
    required String confirmPin,
  }) async {
    _setLoading(true);
    _setError(null);

    final result = await AuthService.instance.changePin(currentPin: currentPin, newPin: newPin, confirmPin: confirmPin);

    _setLoading(false);

    if (!result.success) {
      _setError(result.error);
      return false;
    }

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
      role: pendingRole?.value ?? role ?? 'Worker',
      language: language ?? 'en',
      name: pendingName!,
      age: pendingAge!,
      gender: pendingGender!,
      aadhaarNumber: pendingAadhaar,
      category: pendingCategory,
      primarySkill: pendingSkill,
      specialization: pendingSpecialization,
      customSkill: pendingCustomSkill,
      customSpecialization: pendingCustomSpecialization,
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
    phone = null;
    role = null;
    language = null;
    isRegistered = false;
    hasPin = false;
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
    pendingAadhaarPhoto = null;
    pendingCategory = null;
    pendingSkill = null;
    pendingSpecialization = null;
    pendingCustomSkill = null;
    pendingCustomSpecialization = null;
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
