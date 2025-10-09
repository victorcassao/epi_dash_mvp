import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_camera_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_camera_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:get/get.dart';

class AdminAddCameraBindings extends Bindings {
  @override
  void dependencies() {
    final adminAuth = Get.find<AdminAuthController>();

    Get.lazyPut<AdminAddCameraController>(
          () => AdminAddCameraController(
        cameraService: Get.find<AdminCameraService>(),
        companyService: Get.find<AdminCompanyService>(),
        token: adminAuth.token.value,
      ),
    );
  }
}