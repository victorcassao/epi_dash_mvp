import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthController>();

    final token = auth.token.value;
    final isValid = token.isNotEmpty && !_isExpired(token);

    if (!isValid) {
      return const RouteSettings(name: Routes.login);
    }

    return null; // segue para rota normalmente
  }

  bool _isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true; // se o token for inválido ou malformado, considera expirado
    }
  }
}
