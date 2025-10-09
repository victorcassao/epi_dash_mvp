import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:get/get.dart';

class AdminStreamsListController extends GetxController {
  final AdminStreamService streamService;
  final String token;

  AdminStreamsListController({
    required this.streamService,
    required this.token,
  });

  // ============ STATE ============
  var allStreams = <AdminStreamModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Filtros
  var selectedStatus = Rxn<String>();
  var searchLocation = ''.obs;

  // ============ COMPUTED ============
  List<AdminStreamModel> get filteredStreams {
    return allStreams.where((stream) {
      final matchesLocation = stream.cameraLocation
          .toLowerCase()
          .contains(searchLocation.value.toLowerCase());

      final matchesStatus = selectedStatus.value == null ||
          stream.streamCurrentStatus == selectedStatus.value;

      return matchesLocation && matchesStatus;
    }).toList();
  }

  // ============ METHODS ============
  @override
  void onInit() {
    super.onInit();
    loadStreams();
  }

  Future<void> loadStreams() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final streams = await streamService.fetchAllStreams(token);
      allStreams.assignAll(streams);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível carregar as streams: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void updateLocationFilter(String value) {
    searchLocation.value = value;
  }

  void updateStatusFilter(String? value) {
    selectedStatus.value = value;
  }

  void clearFilters() {
    searchLocation.value = '';
    selectedStatus.value = null;
  }

  Future<void> refresh() async {
    await loadStreams();
  }
}