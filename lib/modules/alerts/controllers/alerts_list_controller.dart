import 'package:epi_dash_mvp/modules/alerts/models/alert_model.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class AlertsListController extends GetxController {
  final AlertService alertService;
  final int companyId;
  final String token;

  AlertsListController({
    required this.alertService,
    required this.companyId,
    required this.token,
  });

  // ============ STATE ============
  var alerts = <AlertModel>[].obs;
  var isLoading = false.obs;
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
    loadAlerts();
  }

  Future<void> loadAlerts() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await alertService.fetchCompanyAlerts(
        companyId: companyId,
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
