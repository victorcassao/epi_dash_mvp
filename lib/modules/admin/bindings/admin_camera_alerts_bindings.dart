import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_camera_alerts_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class AdminCameraAlertsBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AdminAuthController>();

    // Recuperar parâmetros da rota
    final companyIdParam = Get.parameters['company_id'];
    final cameraIdParam = Get.parameters['camera_id'];

    final int companyId = int.tryParse(companyIdParam ?? '0') ?? 0;
    final int cameraId = int.tryParse(cameraIdParam ?? '0') ?? 0;

    Get.lazyPut<AdminCameraAlertsController>(
          () => AdminCameraAlertsController(
        alertService: Get.find<AlertService>(),
        companyId: companyId,
        cameraId: cameraId,
        token: auth.token.value,
      ),
    );
  }
}