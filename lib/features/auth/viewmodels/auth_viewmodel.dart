import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../service/auth_service.dart';

enum AuthState { idle, loading, success, error }
enum AuthScreen { onboarding, signIn, register, home }

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  AuthState _state = AuthState.idle;
  AuthScreen _screen = AuthScreen.onboarding;
  String? _errorMessage;

  // The currently logged-in user — displayed on HomeScreen
  UserModel? _currentUser;

  // ── Getters ───────────────────────────────────────────────
  AuthState get state => _state;
  AuthScreen get screen => _screen;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;

  // ── Form Controllers ──────────────────────────────────────
  final signInEmailController = TextEditingController();
  final signInPasswordController = TextEditingController();

  final registerNameController = TextEditingController();
  final registerBusinessController = TextEditingController();
  final registerPhoneController = TextEditingController();
  final registerEmailController = TextEditingController();
  final registerPasswordController = TextEditingController();

  bool _obscureSignInPassword = true;
  bool _obscureRegisterPassword = true;
  int _currentOnboardingPage = 0;

  bool get obscureSignInPassword => _obscureSignInPassword;
  bool get obscureRegisterPassword => _obscureRegisterPassword;
  int get currentOnboardingPage => _currentOnboardingPage;

  // ── Navigation ────────────────────────────────────────────
  void goToScreen(AuthScreen screen) {
    _screen = screen;
    _state = AuthState.idle;
    _errorMessage = null;
    notifyListeners();
  }

  void toggleSignInPasswordVisibility() {
    _obscureSignInPassword = !_obscureSignInPassword;
    notifyListeners();
  }

  void toggleRegisterPasswordVisibility() {
    _obscureRegisterPassword = !_obscureRegisterPassword;
    notifyListeners();
  }

  void setOnboardingPage(int page) {
    _currentOnboardingPage = page;
    notifyListeners();
  }

  // ── Sign In ───────────────────────────────────────────────
  Future<void> signIn() async {
    if (signInEmailController.text.isEmpty ||
        signInPasswordController.text.isEmpty) {
      _errorMessage = 'Please fill in all fields';
      _state = AuthState.error;
      notifyListeners();
      return;
    }

    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      // Call service — either returns UserModel or throws AuthException
      _currentUser = await _authService.signInWithEmail(
        email: signInEmailController.text,
        password: signInPasswordController.text,
      );

      _state = AuthState.success;
      _screen = AuthScreen.home; // Navigate to home on success
    } on AuthException catch (e) {
      _errorMessage = e.message; // Show exact message from service
      _state = AuthState.error;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = AuthState.error;
    }

    notifyListeners();
  }

  // ── Register ──────────────────────────────────────────────
  Future<void> register() async {
    if (registerNameController.text.isEmpty ||
        registerEmailController.text.isEmpty ||
        registerPasswordController.text.isEmpty) {
      _errorMessage = 'Please fill in all required fields';
      _state = AuthState.error;
      notifyListeners();
      return;
    }

    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.registerWithEmail(
        name: registerNameController.text,
        email: registerEmailController.text,
        password: registerPasswordController.text,
        businessName: registerBusinessController.text,
        phone: registerPhoneController.text,
      );

      _state = AuthState.success;
      _screen = AuthScreen.home;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      _state = AuthState.error;
    } catch (_) {
      _errorMessage = 'Something went wrong. Please try again.';
      _state = AuthState.error;
    }

    notifyListeners();
  }

  // ── Google Sign In ────────────────────────────────────────
  Future<void> signInWithGoogle() async {
    _state = AuthState.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      _currentUser = await _authService.signInWithGoogle();
      _state = AuthState.success;
      _screen = AuthScreen.home;
    } on AuthException catch (e,stackTrace) {
      _errorMessage = e.message;
      print(e.toString());
      print(stackTrace);
      _state = AuthState.error;
    } catch (_) {
      _errorMessage = 'Google sign-in failed. Please try again.';
      print(AuthState.error.toString());
      _state = AuthState.error;
    }

    notifyListeners();
  }

  // ── Logout ────────────────────────────────────────────────
  Future<void> logout() async {
    await _authService.signOut();  // Signs out from Firebase + Google
    _currentUser = null;           // Clear cached user data
    _screen = AuthScreen.onboarding;
    _state = AuthState.idle;

    // Clear all form fields
    signInEmailController.clear();
    signInPasswordController.clear();
    registerNameController.clear();
    registerBusinessController.clear();
    registerPhoneController.clear();
    registerEmailController.clear();
    registerPasswordController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    signInEmailController.dispose();
    signInPasswordController.dispose();
    registerNameController.dispose();
    registerBusinessController.dispose();
    registerPhoneController.dispose();
    registerEmailController.dispose();
    registerPasswordController.dispose();
    super.dispose();
  }
}