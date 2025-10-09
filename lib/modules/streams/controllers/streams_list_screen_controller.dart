import 'package:get/get.dart';
import '../models/stream_model.dart';
import '../services/stream_service.dart';

class StreamsListScreenController extends GetxController {
  final StreamService streamService;
  final int companyId;
  final String token;

  StreamsListScreenController({
    required this.streamService,
    required this.companyId,
    required this.token,
  });

  final streams = <StreamModel>[].obs;
  final isLoading = false.obs;

  Future<void> loadStreams() async {
    isLoading.value = true;
    try {
      final data = await streamService.fetchAllStreamsByCompanyId(companyId, token);
      streams.assignAll(data);
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }




}
