import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/modules/streams/controllers/streams_list_screen_controller.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:get/get.dart';

class StreamListBindings extends Bindings {
  @override
  void dependencies() {
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    Get.lazyPut<StreamsListScreenController>(
          () => StreamsListScreenController(
        streamService: Get.find<StreamService>(),
        companyId: user?.employee?.company?.companyId ?? 0,
        token: auth.token.value,
      ),
    );
  }
}
