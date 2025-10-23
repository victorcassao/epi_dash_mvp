import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/modules/streams/controllers/stream_detail_controller.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class StreamDetailBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    // Recuperar stream_id dos parâmetros da rota
    final streamIdParam = Get.parameters['stream_id'];
    final companyIdParam = Get.parameters['company_id'];
    
    final int streamId = int.tryParse(streamIdParam ?? '0') ?? 0;
    final int companyId = int.tryParse(companyIdParam ?? '0') ?? 0;

    Get.lazyPut<StreamDetailController>(
          () => StreamDetailController(
        streamService: Get.find<StreamService>(),
        // companyId: user?.employee?.company?.companyId ?? 0,
        companyId: companyId,
        streamId: streamId,
        token: auth.token.value,
      ),
    );
  }
}
