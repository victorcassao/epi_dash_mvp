import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/controllers/camera_alerts_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class CameraAlertsBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    // Recuperar parâmetros da rota
    final companyIdParam = Get.parameters['company_id'];
    final cameraIdParam = Get.parameters['camera_id'];

    final int companyId = int.tryParse(companyIdParam ?? '0') ??
        user?.employee?.company?.companyId ?? 0;
    final int cameraId = int.tryParse(cameraIdParam ?? '0') ?? 0;

    Get.lazyPut<CameraAlertsController>(
          () => CameraAlertsController(
        alertService: Get.find<AlertService>(),
        companyId: companyId,
        cameraId: cameraId,
        token: auth.token.value,
      ),
    );
  }
}
