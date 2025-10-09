import 'package:epi_dash_mvp/modules/streams/controllers/stream_detail_controller.dart';
import 'package:epi_dash_mvp/modules/streams/screens/widgets/stream_card.dart';
import 'package:epi_dash_mvp/common/widgets/media_player/stream_player_switcher.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StreamDetailScreen extends GetView<StreamDetailController> {
  const StreamDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Carregar dados quando a tela abrir
    controller.loadStreamDetail();

    return Scaffold(
      body: Obx(() {
        // Estado de carregamento
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Estado de erro / stream não encontrada
        if (controller.stream.value == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Stream não encontrada',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.errorMessage.value.isNotEmpty
                      ? controller.errorMessage.value
                      : 'Não foi possível carregar os detalhes da stream',
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => controller.loadStreamDetail(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () {
                    if (Get.previousRoute.isNotEmpty) {
                      Get.back();
                    } else {
                      Get.offAllNamed(Routes.listStreams);
                    }
                  },
                  child: const Text('Voltar para lista'),
                ),
              ],
            ),
          );
        }

        // Estado de sucesso
        final stream = controller.stream.value!;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔙 Botão de voltar
              TextButton.icon(
                onPressed: () {
                  if (Get.previousRoute.isNotEmpty) {
                    Get.back();
                  } else {
                    Get.offAllNamed(Routes.listStreams);
                  }
                },
                icon: const Icon(Icons.arrow_back),
                label: const Text('Voltar'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  side: const BorderSide(color: Colors.blue),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),

              // 🧩 Card e Player lado a lado
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card da stream (lado esquerdo)
                    Expanded(
                      flex: 1,
                      child: StreamCard(stream: stream),
                    ),
                    const SizedBox(width: 16),
                    // Player (lado direito)
                    Expanded(
                      flex: 1,
                      child: StreamPlayerSwitcher(
                        accessKey: stream.accessKey,
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