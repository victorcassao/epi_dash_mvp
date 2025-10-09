import 'package:epi_dash_mvp/modules/admin/media_player/admin_hls_player.dart';
import 'package:flutter/material.dart';

class AdminStreamPlayerSwitcher extends StatefulWidget {
  final String accessKey;

  const AdminStreamPlayerSwitcher({super.key, required this.accessKey});

  @override
  State<AdminStreamPlayerSwitcher> createState() => _AdminStreamPlayerSwitcherState();
}

class _AdminStreamPlayerSwitcherState extends State<AdminStreamPlayerSwitcher> {
  late String selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = 'original'; // ou 'processed'
  }

  String get _currentUrl {
    final base = selectedType == 'original' ? 'live' : 'processed';
    return 'http://localhost:8888/$base/${widget.accessKey}/index.m3u8';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: ToggleButtons(
            isSelected: [selectedType == 'original', selectedType == 'processed'],
            onPressed: (index) {
              setState(() {
                selectedType = index == 0 ? 'original' : 'processed';
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Original'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Processado'),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: AdminHlsPlayer(hlsUrl: _currentUrl),
          ),
        ),
      ],
    );
  }
}
