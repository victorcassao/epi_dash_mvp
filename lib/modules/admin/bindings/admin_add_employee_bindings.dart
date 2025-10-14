import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_employee_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_employee_service.dart';
import 'package:get/get.dart';

class AdminAddEmployeeBindings extends Bindings {
  @override
  void dependencies() {
    final adminAuth = Get.find<AdminAuthController>();

    Get.lazyPut<AdminAddEmployeeController>(
          () => AdminAddEmployeeController(
        employeeService: Get.find<AdminEmployeeService>(),
        companyService: Get.find<AdminCompanyService>(),
        token: adminAuth.token.value,
      ),
    );
  }
}