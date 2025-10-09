import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_streams_list_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:get/get.dart';

class AdminStreamsListBindings extends Bindings {
  @override
  void dependencies() {
    final adminAuth = Get.find<AdminAuthController>();

    Get.lazyPut<AdminStreamsListController>(
          () => AdminStreamsListController(
        streamService: Get.find<AdminStreamService>(),
        token: adminAuth.token.value,
      ),
    );
  }
}
