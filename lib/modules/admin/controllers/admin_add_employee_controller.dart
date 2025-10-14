import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_employee_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_employee_service.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddEmployeeController extends GetxController {
  final AdminEmployeeService employeeService;
  final AdminCompanyService companyService;
  final String token;

  AdminAddEmployeeController({
    required this.employeeService,
    required this.companyService,
    required this.token,
  });

  // ============ STATE ============
  var isLoading = false.obs;
  var isLoadingCompanies = false.obs;
  var errorMessage = ''.obs;
  var companies = <AdminCompanyModel>[].obs;
  var selectedCompany = Rxn<AdminCompanyModel>();

  // ============ LIFECYCLE ============
  @override
  void onInit() {
    super.onInit();
    loadCompanies();
  }

  // ============ METHODS ============
  Future<void> loadCompanies() async {
    isLoadingCompanies.value = true;
    try {
      final data = await companyService.fetchAllCompanies(token);
      companies.assignAll(data);
      selectedCompany.value = null;

    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível carregar empresas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } finally {
      isLoadingCompanies.value = false;
    }
  }

  // ✅ Removido parâmetro "role"
  Future<void> createEmployee({
    required String name,
    required String email,
    required String username,
    required String password,
  }) async {
    // Validação
    if (selectedCompany.value == null) {
      Get.snackbar(
        'Erro',
        'Selecione uma empresa',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      // ✅ Criando employee sem role
      final employee = AdminEmployeeModel(
        name: name,
        email: email,
        username: username,
        password: password,
        companyId: selectedCompany.value!.id!,
        // role não é mais enviado
      );

      await employeeService.createEmployee(employee, token);

      Get.snackbar(
        'Sucesso',
        'Funcionário cadastrado com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      await Future.delayed(const Duration(milliseconds: 500));
      Get.toNamed(AdminRoutes.adminListStreams);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível cadastrar funcionário: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } finally {
      isLoading.value = false;
    }
  }
}