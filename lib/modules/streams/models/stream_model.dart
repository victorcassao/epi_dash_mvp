import 'package:intl/intl.dart';

class StreamModel {
  final int streamId;
  final int cameraId;
  final String model;
  final String location;
  final bool isActive;
  final String accessKey;
  final int targetFps;
  final String currentStatus;
  final DateTime? lastStatusAt;
  final bool shouldStream;

  StreamModel({
    required this.streamId,
    required this.cameraId,
    required this.model,
    required this.location,
    required this.isActive,
    required this.accessKey,
    required this.targetFps,
    required this.currentStatus,
    required this.lastStatusAt,
    required this.shouldStream,
  });

  String get formattedLastStatus {
    if (lastStatusAt == null) return "-";
    final local = lastStatusAt!.toLocal();
    return DateFormat("dd/MM/yyyy HH:mm").format(local);
  }

  factory StreamModel.fromJson(Map<String, dynamic> json) {
    return StreamModel(
      streamId: json['stream_id'],
      cameraId: json['camera_id'],
      model: json['model'],
      location: json['location'],
      isActive: json['is_active'],
      accessKey: json['access_key'],
      targetFps: json['target_fps'],
      currentStatus: json['current_status'],
      lastStatusAt: DateTime.parse(json['last_status_at']),
      shouldStream: json['should_stream'],
    );
  }
}
