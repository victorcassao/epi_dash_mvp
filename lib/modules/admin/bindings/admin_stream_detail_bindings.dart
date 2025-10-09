import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_stream_detail_screen_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:get/get.dart';

class AdminStreamDetailBindings extends Bindings {
  @override
  void dependencies() {
    // Recuperar auth para obter o token
    final adminAuth = Get.find<AdminAuthController>();

    // Recuperar stream_id dos parâmetros da rota
    final streamIdParam = Get.parameters['stream_id'];
    final int streamId = int.tryParse(streamIdParam ?? '0') ?? 0;

    // Criar controller com lazyPut
    Get.lazyPut<AdminStreamDetailScreenController>(
          () => AdminStreamDetailScreenController(
        streamService: Get.find<AdminStreamService>(),
        streamId: streamId,
        token: adminAuth.token.value,
      ),
    );
  }
}
