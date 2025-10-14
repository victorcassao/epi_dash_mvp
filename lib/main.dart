import 'package:epi_dash_mvp/app.dart';
import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/common/bindings/app_bindings.dart';
import 'package:epi_dash_mvp/common/config/environment.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Environment _determineEnvironment() {
  return Environment.development;

}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final environment = _determineEnvironment();
  final appConfig = AppConfig(environment: environment);
  Get.put<AppConfig>(appConfig, permanent: true);

  AppBindings().dependencies();

  final auth = Get.find<AuthController>();
  final adminAuth = Get.find<AdminAuthController>();

  await auth.initSession();
  await adminAuth.initSession();

  runApp(const App());
}
