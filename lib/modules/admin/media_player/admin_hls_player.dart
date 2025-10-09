import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AdminHlsPlayer extends StatefulWidget {
  final String hlsUrl;

  const AdminHlsPlayer({
    Key? key,
    required this.hlsUrl,
  }) : super(key: key);

  @override
  State<AdminHlsPlayer> createState() => _AdminHlsPlayerState();
}

class _AdminHlsPlayerState extends State<AdminHlsPlayer> {
  VideoPlayerController? _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  @override
  void didUpdateWidget(covariant AdminHlsPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinicializa o player se a URL da stream mudar
    if (oldWidget.hlsUrl != widget.hlsUrl) {
      _disposeController();
      _initializePlayer();
    }
  }

  Future<void> _initializePlayer() async {
    setState(() {
      _isInitialized = false;
      _errorMessage = null;
    });

    try {
      final controller = VideoPlayerController.networkUrl(Uri.parse(widget.hlsUrl));
      _controller = controller;

      await controller.initialize();

      if (!mounted) return; // ✅ Garante que o widget ainda está ativo

      controller.setLooping(true);
      controller.setVolume(0.0);
      controller.play();

      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  void _disposeController() {
    _controller?.pause();
    _controller?.dispose();
    _controller = null;
  }

  @override
  void dispose() {
    _disposeController();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller == null) return;
    setState(() {
      _controller!.value.isPlaying
          ? _controller!.pause()
          : _controller!.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Erro ao carregar o vídeo',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return const Center(child: CircularProgressIndicator());
    }

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
}
