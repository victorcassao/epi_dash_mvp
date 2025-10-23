import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:get/get.dart';

class AdminStreamDetailScreenController extends GetxController{
  final AdminStreamService streamService;
  final int streamId;
  final String token;

  AdminStreamDetailScreenController({
    required this.streamService,
    required this.streamId,
    required this.token
  });

  final stream = <AdminCameraStreamModel>[].obs;
  final isLoading = false.obs;

  Future<void> loadAdminStreamDetail() async {
    isLoading.value = true;
    print("Carregando...");
    try{
      final data = await streamService.fetchAdminStreamDetail(
        token,
        streamId
      );
      stream.assign(data);
    } catch (e) {
      Get.snackbar('Erro', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
