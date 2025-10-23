import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/controllers/alerts_list_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class AlertsListBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    Get.lazyPut<AlertsListController>(
          () => AlertsListController(
        alertService: Get.find<AlertService>(),
        companyId: user?.employee?.company?.companyId ?? 0,
        token: auth.token.value,
      ),
    );
  }
}
