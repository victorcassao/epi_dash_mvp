import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class HlsPlayer extends StatefulWidget {
  final String hlsUrl;
  const HlsPlayer({required this.hlsUrl, Key? key}) : super(key: key);

  @override
  State<HlsPlayer> createState() => _HlsPlayerState();
}

class _HlsPlayerState extends State<HlsPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      _controller = VideoPlayerController.networkUrl(Uri.parse(widget.hlsUrl));
      await _controller.initialize();
      _controller.setLooping(true);
      _controller.setVolume(0.0); // MUTAR O VÍDEO
      _controller.play();
      setState(() {
        _isInitialized = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    setState(() {
      _controller.value.isPlaying
          ? _controller.pause()
          : _controller.play();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return Center(
        child: Text(
          'Erro ao carregar o vídeo:\n$_errorMessage',
          style: const TextStyle(color: Colors.red),
          textAlign: TextAlign.center,
        ),
      );
    }

    if (!_isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        AspectRatio(
          aspectRatio: _controller.value.aspectRatio,
          child: VideoPlayer(_controller),
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: _togglePlayPause,
            backgroundColor: Colors.white70,
            child: Icon(
              _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }
}
