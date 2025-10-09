import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:flutter/material.dart';

class AdminStreamCard extends StatelessWidget {
  final AdminStreamModel stream;
  const AdminStreamCard({
    required this.stream,
    super.key
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
          _infoTile('Localização', stream.cameraLocation),
          // _infoTile('Modelo', stream.),
          _infoTile('Status Atual', stream.streamCurrentStatus ?? ""),
          _infoTile('FPS', stream.streamTargetFps.toString()),
          _infoTile('Última Atualização', stream.formattedLastStatus),
          _infoTile('Ativa', stream.cameraIsActive ? 'Sim' : 'Não'),
          _infoTile('Deve Transmitir', stream.streamShouldStream ? 'Sim' : 'Não'),
          _infoTile('Access Key', stream.streamAccessKey),
          _infoTile('Link HLS', 'http://localhost:8889/live/${stream.streamAccessKey}/index.m3u8'),
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
