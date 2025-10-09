import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:get/get.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import '../controllers/admin_auth_controller.dart';
import 'package:flutter/material.dart';

class AdminAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final admin = Get.find<AdminAuthController>();
    final token = admin.token.value;
    final isValid = token.isNotEmpty && !_isExpired(token);
    if (!isValid) {
      return const RouteSettings(name: AdminRoutes.adminLogin);
    }
    return null;
  }

  bool _isExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (_) {
      return true;
    }
  }
}
