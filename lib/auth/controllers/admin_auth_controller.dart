import 'package:epi_dash_mvp/auth/models/user_profile_model.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/admin_auth_service.dart';
import '../services/admin_auth_storage.dart';
import 'package:flutter/material.dart';

enum AdminAuthStatus {
  initial,
  authenticated,
  unauthenticated,
  loading,
}

class AdminAuthController extends GetxController {
  final AdminAuthService authService;
  final AdminAuthStorage authStorage;

  AdminAuthController({
    required this.authService,
    required this.authStorage,
  });

  var status = AdminAuthStatus.initial.obs;
  var token = ''.obs;
  var user = Rxn<UserProfile>();

  Future<void> initSession() async {
    final stored = await authStorage.readToken();
    if (stored != null && !_isTokenExpired(stored)) {
      token.value = stored;
      status.value = AdminAuthStatus.authenticated;
      await fetchCurrentUser();
    } else {
      token.value = '';
      status.value = AdminAuthStatus.unauthenticated;
    }
  }

  Future<void> login(String username, String password) async {
    status.value = AdminAuthStatus.loading;
    try {
      final t = await authService.login(
        username: username,
        password: password,
      );
      await authStorage.saveToken(t);
      token.value = t;
      status.value = AdminAuthStatus.authenticated;

      await fetchCurrentUser();
      Get.offAllNamed(AdminRoutes.adminHome);
    } catch (e) {
      status.value = AdminAuthStatus.unauthenticated;
      Get.snackbar(
        'Erro ao autenticar (Admin)',
        _parseErrorMessage(e),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      // Pode reutilizar endpoint /me ou criar /admin/me, conforme backend
      final u = await authService.getCurrentUserProfile(token.value);
      user.value = u;
    } catch (e) {
      user.value = null;
      Get.snackbar(
        'Erro ao carregar usuário (Admin)',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  Future<void> logout() async {
    token.value = '';
    user.value = null;
    status.value = AdminAuthStatus.unauthenticated;
    await authStorage.deleteToken();
    Get.offAllNamed('/admin/login');
  }

  bool _isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }

  String _parseErrorMessage(Object e) {
    final raw = e.toString();
    if (raw.contains('Este portal é apenas para administradores')) {
      return 'Acesso restrito a administradores.';
    } else if (raw.contains('Invalid username or password')) {
      return 'Usuário ou senha inválidos.';
    } else {
      return 'Erro inesperado. Tente novamente.';
    }
  }
}
