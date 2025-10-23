import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_service.dart';
import 'package:epi_dash_mvp/auth/services/admin_auth_storage.dart';
import 'package:epi_dash_mvp/auth/services/auth_service.dart';
import 'package:epi_dash_mvp/auth/services/auth_storage.dart';
import 'package:epi_dash_mvp/common/config/environment.dart';
import 'package:epi_dash_mvp/common/controllers/admin_sidebar_controller.dart';
import 'package:epi_dash_mvp/common/controllers/sidebar_controller.dart';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_camera_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_employee_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    final appConfig = Get.find<AppConfig>();
    // ============ ENDPOINTS (SINGLETON) ==================
    Get.put<AuthEndpoints>(
      AuthEndpoints(appConfig.apiBaseUrl),
      permanent: true
    );

    Get.put<AdminEndpoints>(
      AdminEndpoints(appConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<UserEndpoints>(
      UserEndpoints(appConfig.apiBaseUrl),
      permanent: true,
    );

    Get.put<HlsEndpoints>(
      HlsEndpoints(appConfig.hlsBaseUrl),
      permanent: true,
    );

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
      AdminAuthService(endpoints: Get.find<AuthEndpoints>()),
      permanent: true,
    );

    Get.put<AdminCameraService>(
      AdminCameraService(endpoints: Get.find<AdminEndpoints>()),
      permanent: true,
    );

    Get.put<AdminCompanyService>(
      AdminCompanyService(endpoints: Get.find<AdminEndpoints>()),
      permanent: true,
    );

    Get.put<AdminEmployeeService>(
      AdminEmployeeService(endpoints: Get.find<AdminEndpoints>()),
      permanent: true,
    );

    Get.put<AdminStreamService>(
      AdminStreamService(endpoints: Get.find<AdminEndpoints>()),
      permanent: true,
    );

    // ======== USER SERVICES ========
    Get.put<AuthService>(
      AuthService(endpoints: Get.find<AuthEndpoints>()),
      permanent: true,
    );

    Get.put<StreamService>(
      StreamService(endpoints: Get.find<UserEndpoints>()),
      permanent: true,
    );

    Get.put<AlertService>(
      AlertService(endpoints: Get.find<UserEndpoints>()),
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
