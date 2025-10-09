// ==========================================
// lib/modules/streams/media_player/stream_player_switcher.dart
// CRIAR ESTE ARQUIVO COMPLETO
// ==========================================

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class StreamPlayerSwitcher extends StatefulWidget {
  final String accessKey;

  const StreamPlayerSwitcher({super.key, required this.accessKey});

  @override
  State<StreamPlayerSwitcher> createState() => _StreamPlayerSwitcherState();
}

class _StreamPlayerSwitcherState extends State<StreamPlayerSwitcher> {
  late String selectedType;
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    selectedType = 'original';
    _initializePlayer();
  }

  String get _currentUrl {
    final base = selectedType == 'original' ? 'live' : 'processed';
    return 'http://localhost:8888/$base/${widget.accessKey}/index.m3u8';
  }

  String get _videoTypeLabel {
    return selectedType == 'original' ? 'original' : 'processado';
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isLoading = true;
      _isInitialized = false;
      _errorMessage = null;
    });

    try {
      // Dispose do controller anterior
      await _controller?.dispose();

      final controller = VideoPlayerController.networkUrl(
        Uri.parse(_currentUrl),
      );
      _controller = controller;

      await controller.initialize();

      if (!mounted) return;

      controller.setLooping(true);
      controller.setVolume(0.0);
      controller.play();

      setState(() {
        _isInitialized = true;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
        _isInitialized = false;
      });
    }
  }

  @override
  void dispose() {
    _controller?.pause();
    _controller?.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying ? _controller!.pause() : _controller!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Toggle buttons
        Center(
          child: ToggleButtons(
            isSelected: [
              selectedType == 'original',
              selectedType == 'processed'
            ],
            onPressed: (index) {
              setState(() {
                selectedType = index == 0 ? 'original' : 'processed';
              });
              _initializePlayer();
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

        // Player container
        Expanded(
          child: Container(
            color: Colors.black,
            padding: const EdgeInsets.all(16),
            child: _buildPlayerContent(),
          ),
        ),
      ],
    );
  }

  Widget _buildPlayerContent() {
    // Estado de carregamento
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Colors.white),
            SizedBox(height: 16),
            Text(
              'Carregando vídeo...',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    }

    // Estado de erro
    if (_errorMessage != null) {
      return Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          margin: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: Colors.red.shade900,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.red.shade400, width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.white,
              ),
              const SizedBox(height: 16),
              Text(
                'Erro ao carregar vídeo $_videoTypeLabel',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Não foi possível conectar ao stream de vídeo.',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Verifique se o servidor está rodando e se o vídeo $_videoTypeLabel está disponível.',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: _initializePlayer,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Tentar novamente'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red.shade900,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        selectedType = selectedType == 'original'
                            ? 'processed'
                            : 'original';
                      });
                      _initializePlayer();
                    },
                    icon: const Icon(Icons.swap_horiz),
                    label: Text(
                        selectedType == 'original'
                            ? 'Tentar Processado'
                            : 'Tentar Original'
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpansionTile(
                title: const Text(
                  'Detalhes técnicos',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
                iconColor: Colors.white70,
                collapsedIconColor: Colors.white70,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'URL: $_currentUrl',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Erro: $_errorMessage',
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 10,
                            fontFamily: 'monospace',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    // Estado de sucesso - player funcionando
    if (_isInitialized && _controller != null) {
      return Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: VideoPlayer(_controller!),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _togglePlayPause,
              backgroundColor: Colors.white70,
              child: Icon(
                _controller!.value.isPlaying ? Icons.pause : Icons.play_arrow,
                color: Colors.black,
              ),
            ),
          ),
        ],
      );
    }

    // Estado padrão
    return const Center(
      child: Text(
        'Nenhum vídeo disponível',
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
