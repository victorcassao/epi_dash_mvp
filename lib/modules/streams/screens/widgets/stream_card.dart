// lib/modules/streams/screens/widgets/stream_card.dart
// CRIAR ESTE ARQUIVO
import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';
import 'package:flutter/material.dart';

class StreamCard extends StatelessWidget {
  final StreamModel stream;

  const StreamCard({
    required this.stream,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          _infoTile('Última Atualização', stream.formattedLastStatus),
          _infoTile('Ativa', stream.isActive ? 'Sim' : 'Não'),
          _infoTile('Deve Transmitir', stream.shouldStream ? 'Sim' : 'Não'),
          _infoTile('Access Key', stream.accessKey),
          _infoTile('Link HLS', 'http://localhost:8889/live/${stream.accessKey}/index.m3u8'),
        ],
      ),
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