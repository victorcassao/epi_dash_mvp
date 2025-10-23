import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class StreamsListScreenController extends GetxController {
  final StreamService streamService;
  final int companyId;
  final String token;

  StreamsListScreenController({
    required this.streamService,
    required this.companyId,
    required this.token,
  });

  // ============ STATE ============
  var streams = <CameraStreamModel>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // Filtros
  var selectedStatus = Rxn<String>();
  var searchLocation = ''.obs;

  // ============ COMPUTED ============
  List<CameraStreamModel> get filteredStreams {
    return streams.where((stream) {
      final matchesLocation = stream.location
          .toLowerCase()
          .contains(searchLocation.value.toLowerCase());

      final matchesStatus = selectedStatus.value == null ||
          stream.currentStatus == selectedStatus.value;

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
      final data = await streamService.fetchAllStreamsByCompanyId(companyId, token);
      print(data);
      streams.assignAll(data);
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