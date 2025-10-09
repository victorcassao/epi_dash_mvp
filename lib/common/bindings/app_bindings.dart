import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_service.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_storage.dart';
import 'package:epi_dash_mvp/auth/services/auth_service.dart';
import 'package:epi_dash_mvp/auth/services/auth_storage.dart';
import 'package:epi_dash_mvp/common/config/app_config.dart';
import 'package:epi_dash_mvp/common/controllers/admin_sidebar_controller.dart';
import 'package:epi_dash_mvp/common/controllers/sidebar_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_camera_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_employee_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // ============ STORAGE ==================
    Get.put<AuthStorage>(
      AuthStorage(),
      permanent: true,
    );

    Get.put<AdminAuthStorage>(
      AdminAuthStorage(),
      permanent: true,
    );

    // ============ SERVICES ==================
    // ======== ADMIN SERVICES ========
    Get.put<AdminAuthService>(
      AdminAuthService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<AdminCameraService>(
      AdminCameraService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<AdminCompanyService>(
      AdminCompanyService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<AdminEmployeeService>(
      AdminEmployeeService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<AdminStreamService>(
      AdminStreamService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    // ======== USER SERVICES ========
    Get.put<AuthService>(
      AuthService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<StreamService>(
      StreamService(baseUrl: AppConfig.apiBaseUrl),
      permanent: true,
    );

    // ============ AUTH CONTROLLERS ============
    Get.put<AuthController>(
      AuthController(
        authService: Get.find<AuthService>(),
        authStorage: Get.find<AuthStorage>(),
      ),
      permanent: true,
    );

    Get.put<AdminAuthController>(
      AdminAuthController(
        authService: Get.find<AdminAuthService>(),
        authStorage: Get.find<AdminAuthStorage>(),
      ),
      permanent: true,
    );

    // ============ LAYOUT CONTROLLER ============
    Get.put<SidebarController>(
      SidebarController(),
      permanent: true,
    );

    Get.put<AdminSidebarController>(
      AdminSidebarController(),
      permanent: true,
    );

  }
}
