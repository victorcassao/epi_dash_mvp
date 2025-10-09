import 'package:epi_dash_mvp/auth/controllers/auth_controller.dart';
import 'package:epi_dash_mvp/common/config/app_config.dart';
import 'package:epi_dash_mvp/modules/streams/controllers/stream_video_player_hls.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:epi_dash_mvp/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';

class StreamDetailScreen extends StatelessWidget {
  const StreamDetailScreen({super.key});

  Future<StreamModel> _fetchStreamDetails(int streamId){
    final streamService = StreamService(baseUrl: AppConfig.apiBaseUrl);
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    final streamModel = streamService.fetchStreamDetail(
        user!.employee!.company!.companyId,
        streamId,
        auth.token.value
    );
    return streamModel;
  }

  @override
  Widget build(BuildContext context) {
    final String? idParam = Get.parameters["stream_id"];
    final int? streamId = int.tryParse(idParam ?? '');

    if (streamId == null){
      return const Scaffold(
        body: Center(
          child: Text('Stream ID não fornecido'),
        ),
      );
    }

    return FutureBuilder<StreamModel>(
        future: _fetchStreamDetails(streamId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Scaffold(
              body: Center(child: CircularProgressIndicator(),),
            );
          }

          if (snapshot.hasError){
            return Scaffold(
              body: Center(
                child: Text(
                  'Erro ao carregar stream:\n${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          if (!snapshot.hasData) {
            return const Scaffold(
              body: Center(child: Text('Stream não encontrada.')),
            );
          }

          final stream = snapshot.data!;
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    if (Get.previousRoute.isNotEmpty){
                      Get.back();
                    } else {
                      Get.offAllNamed(Routes.listStreams);
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
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: Row(
                    children: [
                      // LADO ESQUERDO: DETALHES
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey.shade100,
                          padding: const EdgeInsets.all(24),
                          child: ListView(
                            children: [
                              _infoTile('Stream ID', stream.streamId.toString()),
                              _infoTile('Camera ID', stream.cameraId.toString()),
                              _infoTile('Localização', stream.location),
                              _infoTile('Modelo', stream.model),
                              _infoTile('Status Atual', stream.currentStatus),
                              _infoTile('FPS', stream.targetFps.toString()),
                              _infoTile('Última Atualização', stream.lastStatusAt.toString()),
                              _infoTile('Ativa', stream.isActive ? 'Sim' : 'Não'),
                              _infoTile('Deve Transmitir', stream.shouldStream ? 'Sim' : 'Não'),
                              _infoTile('Access Key', stream.accessKey),
                              _infoTile('Link HLS', 'http://localhost:8889/live/${stream.accessKey}/index.m3u8'),
                            ],
                          ),
                        ),
                      ),
                      // LADO DIREITO: PLAYER HLS
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.black,
                          padding: const EdgeInsets.all(16),
                          child: HlsPlayer(
                            hlsUrl: 'http://localhost:8888/live/${stream.accessKey}/index.m3u8',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );

        }
    );
  }

  Widget _infoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: SelectableText(value),
          ),
        ],
      ),
    );
  }
}
