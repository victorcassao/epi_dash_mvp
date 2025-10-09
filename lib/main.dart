import 'package:epi_dash_mvp/app.dart';
import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/common/bindings/app_bindings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppBindings().dependencies();

  final auth = Get.find<AuthController>();
  final adminAuth = Get.find<AdminAuthController>();

  await auth.initSession();
  await adminAuth.initSession();

  runApp(const App());
}
