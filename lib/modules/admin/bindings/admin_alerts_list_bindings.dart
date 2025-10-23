import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_alerts_list_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class AdminAlertsListBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AdminAuthController>();

    Get.lazyPut<AdminAlertsListController>(
          () => AdminAlertsListController(
        alertService: Get.find<AlertService>(),
        companyService: Get.find<AdminCompanyService>(),
        token: auth.token.value,
      ),
    );
  }
}