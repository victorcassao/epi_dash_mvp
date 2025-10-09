import 'package:epi_dash_mvp/auth/models/user_profile_model.dart';
import 'package:flutter/material.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../services/auth_service.dart';
import '../services/auth_storage.dart';

enum AuthStatus { initial, authenticated, unauthenticated, loading }

class AuthController extends GetxController {
  final AuthService authService;
  final AuthStorage authStorage;

  AuthController({required this.authService, required this.authStorage});

  var status = AuthStatus.initial.obs;
  var token = ''.obs;
  var user = Rxn<UserProfile>();

  /// 🔐 CHAMADO NO main.dart para restaurar a sessão antes de iniciar o app
  Future<void> initSession() async {
    final stored = await authStorage.readToken();

    if (stored != null && !_isTokenExpired(stored)) {
      token.value = stored;
      status.value = AuthStatus.authenticated;
      await fetchCurrentUser();
    } else {
      token.value = '';
      status.value = AuthStatus.unauthenticated;
    }
  }

  Future<void> login(String username, String password) async {
    status.value = AuthStatus.loading;
    try {
      final t = await authService.login(username: username, password: password);
      await authStorage.saveToken(t);
      token.value = t;
      status.value = AuthStatus.authenticated;
      await fetchCurrentUser();
      Get.offAllNamed(Routes.listStreams);
    } catch (e) {
      status.value = AuthStatus.unauthenticated;
      final msg = _parseErrorMessage(e);
      Get.snackbar(
        'Erro ao autenticar',
        msg,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.black,
        duration: const Duration(seconds: 4),
        margin: const EdgeInsets.all(16),
      );
    }
  }

  String _parseErrorMessage(Object e) {
    try {
      final raw = e.toString();
      if (raw.contains('Invalid username or password')) {
        return 'Usuário ou senha inválidos';
      } else if (raw.contains('SocketException')) {
        return 'Não foi possível conectar ao servidor';
      } else if (raw.contains('Superusuários não podem acessar este portal.')){
        return 'Superusuários não podem acessar este portal.';
      }
      return 'Erro inesperado. Tente novamente.';
    } catch (_) {
      return 'Erro ao processar resposta';
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      final u = await authService.getCurrentUserProfile(token.value);
      user.value = u;
    } catch (e) {
      user.value = null;
      Get.snackbar(
        'Erro ao carregar usuário',
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
    status.value = AuthStatus.unauthenticated;
    await authStorage.deleteToken();
    Get.offAllNamed(Routes.login);
  }

  bool _isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }
}
