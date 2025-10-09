import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class StreamDetailController extends GetxController {
  final StreamService streamService;
  final int companyId;
  final int streamId;
  final String token;

  StreamDetailController({
    required this.streamService,
    required this.companyId,
    required this.streamId,
    required this.token,
  });

  // ============ STATE ============
  var stream = Rxn<StreamModel>();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  // ============ METHODS ============
  Future<void> loadStreamDetail() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await streamService.fetchStreamDetail(
        companyId,
        streamId,
        token,
      );
      stream.value = data;
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Erro',
        'Não foi possível carregar a stream: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await loadStreamDetail();
  }
}