// lib/modules/admin/bindings/admin_add_company_bindings.dart
import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_company_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:get/get.dart';

class AdminAddCompanyBindings extends Bindings {
  @override
  void dependencies() {
    final adminAuth = Get.find<AdminAuthController>();

    Get.lazyPut<AdminAddCompanyController>(
          () => AdminAddCompanyController(
        companyService: Get.find<AdminCompanyService>(),
        token: adminAuth.token.value,
      ),
    );
  }
}