import 'package:epi_dash_mvp/modules/alerts/models/alert_model.dart';
import 'package:epi_dash_mvp/modules/alerts/services/alert_service.dart';
import 'package:get/get.dart';

class AdminCameraAlertsController extends GetxController {
  final AlertService alertService;
  final int companyId;
  final int cameraId;
  final String token;

  AdminCameraAlertsController({
    required this.alertService,
    required this.companyId,
    required this.cameraId,
    required this.token,
  });

  // ============ STATE ============
  var alerts = <AlertModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var cameraLocation = ''.obs;

  // Filtros
  var selectedStatus = Rxn<String>();
  var selectedAlertType = Rxn<String>();

  // ============ COMPUTED ============
  List<AlertModel> get filteredAlerts {
    return alerts.where((alert) {
      final matchesStatus = selectedStatus.value == null ||
          alert.status.toUpperCase() == selectedStatus.value!.toUpperCase();

      final matchesAlertType = selectedAlertType.value == null ||
          alert.alertType.toUpperCase() == selectedAlertType.value!.toUpperCase();

      return matchesStatus && matchesAlertType;
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
      final data = await alertService.fetchCameraAlerts(
        companyId: companyId,
        cameraId: cameraId,
        token: token,
      );
      alerts.assignAll(data);

      if (data.isNotEmpty) {
        cameraLocation.value = data.first.cameraLocation;
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível carregar os alertas da câmera: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateStatusFilter(String? value) {
    selectedStatus.value = value;
  }

  void updateAlertTypeFilter(String? value) {
    selectedAlertType.value = value;
  }

  void clearFilters() {
    selectedStatus.value = null;
    selectedAlertType.value = null;
  }

  Future<void> refresh() async {
    await loadAlerts();
  }
}