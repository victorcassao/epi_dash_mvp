import 'package:intl/intl.dart';

class CameraStreamModel {
  final int id;
  final String model;
  final String location;
  final bool isActive;
  final String accessKey;
  final int targetFps;
  final String currentStatus;
  final DateTime? lastStatusAt;
  final bool shouldStream;

  CameraStreamModel({
    required this.id,
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

  factory CameraStreamModel.fromJson(Map<String, dynamic> json) {
    return CameraStreamModel(
      id: json['id'],
      location: json['location'],
      model: json['model'],
      isActive: json['is_active'],
      accessKey: json['access_key'],
      targetFps: json['target_fps'],
      currentStatus: json['current_status'],
      lastStatusAt: json["last_status_at"] != null
            ? DateTime.parse(json["last_status_at"])
            : null,
      shouldStream: json['should_stream'],
    );
  }
}
