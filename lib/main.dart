import 'package:epi_dash_mvp/app.dart';
import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_service.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_storage.dart';
import 'package:epi_dash_mvp/auth/services/auth_service.dart';
import 'package:epi_dash_mvp/auth/services/auth_storage.dart';
import 'package:epi_dash_mvp/common/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final auth = Get.put(
    AuthController(
      authService: AuthService(baseUrl: AppConfig.apiBaseUrl),
      authStorage: AuthStorage(),
    ),
  );

  final admin_auth = Get.put<AdminAuthController>(
    AdminAuthController(
      authService: AdminAuthService(baseUrl: AppConfig.apiBaseUrl),
      authStorage: AdminAuthStorage(),
    ),
  );

  await auth.initSession();
  await admin_auth.initSession();

  runApp(const App());
}
