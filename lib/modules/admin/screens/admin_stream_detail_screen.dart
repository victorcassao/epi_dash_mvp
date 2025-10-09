import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_stream_detail_screen_controller.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:epi_dash_mvp/modules/admin/media_player/stream_player_switcher.dart';
import 'package:epi_dash_mvp/modules/admin/screens/widgets/admin_stream_card.dart';
import 'package:epi_dash_mvp/auth/controllers/admin_auth_controller.dart';
import 'package:epi_dash_mvp/common/config/app_config.dart';

class AdminStreamDetailScreen extends StatelessWidget {
  const AdminStreamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Recupera o parâmetro da rota
    final streamIdParam = Get.parameters['stream_id'];
    final int? streamId = int.tryParse(streamIdParam ?? '');
    if (streamId == null) {
      return const Scaffold(
        body: Center(child: Text('Parâmetro stream_id inválido')),
      );
    }

    // Recupera dependências
    final auth = Get.find<AdminAuthController>();
    final token = auth.token.value;
    final streamService = AdminStreamService(baseUrl: AppConfig.apiBaseUrl);

    // Injeta o controller se ainda não existir
    final controllerExists = Get.isRegistered<AdminStreamDetailScreenController>();
    final controller = controllerExists
        ? Get.find<AdminStreamDetailScreenController>()
        : Get.put(
      AdminStreamDetailScreenController(
        streamService: streamService,
        streamId: streamId,
        token: token,
      )..loadAdminStreamDetail(),
    );

    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.stream.isEmpty) {
          return const Center(child: Text('Stream não encontrada'));
        }

        final stream = controller.stream.first;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Botão de voltar
              TextButton.icon(
                onPressed: () {
                  if (Get.previousRoute.isNotEmpty){
                    Get.back();
                  } else {
                    Get.offAllNamed(AdminRoutes.adminListStreams);
                  }
                },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Voltar'),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    side: const BorderSide(color: Colors.blue),
                    textStyle: const TextStyle(fontSize: 16),
                  )
              ),
              const SizedBox(height: 12),

              // 🧩 Card e Player lado a lado
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card da stream
                    Expanded(
                      flex: 1,
                      child: AdminStreamCard(stream: stream),
                    ),
                    const SizedBox(width: 16),
                    // Player
                    Expanded(
                      flex: 1,
                      child: AdminStreamPlayerSwitcher(
                        accessKey: stream.streamAccessKey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
