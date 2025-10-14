import 'package:epi_dash_mvp/modules/admin/models/admin_camera_model.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_camera_service.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddCameraController extends GetxController {
  final AdminCameraService cameraService;
  final AdminCompanyService companyService;
  final String token;

  AdminAddCameraController({
    required this.cameraService,
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

      // ❌ REMOVIDO: Não seleciona automaticamente a primeira empresa
      // if (companies.isNotEmpty) {
      //   selectedCompany.value = companies.first;
      // }

      // ✅ NOVO: Deixa em branco (null)
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

  Future<void> createCamera({
    required String location,
    required String model,
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
      final camera = AdminCameraModel(
        location: location,
        model: model,
        companyId: selectedCompany.value!.id!,
      );

      await cameraService.createCamera(camera, token);

      Get.snackbar(
        'Sucesso',
        'Câmera cadastrada com sucesso!',
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
        'Não foi possível cadastrar câmera: ${e.toString()}',
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