import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_company_service.dart';
import 'package:epi_dash_mvp/modules/alerts/models/alert_model.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAlertsListController extends GetxController {
  final AlertService alertService;
  final AdminCompanyService companyService;
  final String token;

  AdminAlertsListController({
    required this.alertService,
    required this.companyService,
    required this.token,
  });

  // ============ STATE ============
  var alerts = <AlertModel>[].obs;
  var companies = <AdminCompanyModel>[].obs;
  var selectedCompany = Rxn<AdminCompanyModel>();

  var isLoading = false.obs;
  var isLoadingCompanies = false.obs;
  var errorMessage = ''.obs;

  // Filtros
  var selectedStatus = Rxn<String>();
  var selectedAlertType = Rxn<String>();
  var searchCameraLocation = ''.obs;

  // ============ COMPUTED ============
  List<AlertModel> get filteredAlerts {
    return alerts.where((alert) {
      final matchesLocation = alert.cameraLocation
          .toLowerCase()
          .contains(searchCameraLocation.value.toLowerCase());

      final matchesStatus = selectedStatus.value == null ||
          alert.status.toUpperCase() == selectedStatus.value!.toUpperCase();

      final matchesAlertType = selectedAlertType.value == null ||
          alert.alertType.toUpperCase() == selectedAlertType.value!.toUpperCase();

      return matchesLocation && matchesStatus && matchesAlertType;
    }).toList();
  }

  // ============ METHODS ============
  @override
  void onInit() {
    super.onInit();
    loadCompanies();
  }

  Future<void> loadCompanies() async {
    isLoadingCompanies.value = true;
    try {
      final data = await companyService.fetchAllCompanies(token);
      companies.assignAll(data);

      // Seleciona a primeira empresa automaticamente se houver
      if (companies.isNotEmpty) {
        selectedCompany.value = companies.first;
        loadAlerts();
      }
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

  Future<void> loadAlerts() async {
    if (selectedCompany.value == null) {
      alerts.clear();
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await alertService.fetchCompanyAlerts(
        companyId: selectedCompany.value!.id!,
        token: token,
      );
      alerts.assignAll(data);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os alertas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onCompanyChanged(AdminCompanyModel? company) {
    selectedCompany.value = company;
    if (company != null) {
      clearFilters();
      loadAlerts();
    }
  }

  void updateLocationFilter(String value) {
    searchCameraLocation.value = value;
  }

  void updateStatusFilter(String? value) {
    selectedStatus.value = value;
  }

  void updateAlertTypeFilter(String? value) {
    selectedAlertType.value = value;
  }

  void clearFilters() {
    searchCameraLocation.value = '';
    selectedStatus.value = null;
    selectedAlertType.value = null;
  }

  Future<void> refresh() async {
    await loadAlerts();
  }
}