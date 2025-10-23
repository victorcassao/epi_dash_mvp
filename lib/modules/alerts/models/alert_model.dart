import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class AlertModel {
  final int id;
  final String alertType;
  final String status;
  final String notificationStatus;
  final DateTime detectedAt;
  final int cameraId;
  final String cameraLocation;

  AlertModel({
    required this.id,
    required this.alertType,
    required this.status,
    required this.notificationStatus,
    required this.detectedAt,
    required this.cameraId,
    required this.cameraLocation,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      alertType: json['alert_type'],
      status: json['status'],
      notificationStatus: json['notification_status'],
      detectedAt: DateTime.parse(json['detected_at']),
      cameraId: json['camera_id'],
      cameraLocation: json['camera_location'],
    );
  }

  String get formattedDetectedAt {
    final local = detectedAt.toLocal();
    return DateFormat("dd/MM/yyyy HH:mm:ss").format(local);
  }

  StatusInfo get statusInfo {
    switch (status.toUpperCase()) {
      case 'PENDENTE':
        return StatusInfo('Pendente', Colors.orange, Icons.pending);
      case 'RECONHECIDO':
        return StatusInfo('Reconhecido', Colors.blue, Icons.app_registration);
      case 'RESOLVIDO':
        return StatusInfo('Resolvido', Colors.green, Icons.check_circle);
      case 'DESCARTADO':
        return StatusInfo('Descartado', Colors.grey, Icons.block);
      default:
        return StatusInfo('Desconhecido', Colors.grey, Icons.help_outline);
    }
  }


  NotificationStatusInfo get notificationStatusInfo {
    switch (notificationStatus.toUpperCase()) {
      case 'PENDENTE':
        return NotificationStatusInfo('Pendente', Colors.orange);
      case 'ENVIADO':
        return NotificationStatusInfo('Enviado', Colors.green);
      case 'FALHOU':
        return NotificationStatusInfo('Falha', Colors.red);
      case 'IGNORADO':
        return NotificationStatusInfo('Ignorado', Colors.red);
      default:
        return NotificationStatusInfo('Desconhecido', Colors.grey);
    }
  }

  // ⭐ APENAS 2 TIPOS DE ALERTA
  String get formattedAlertType {
    switch (alertType.toUpperCase()) {
      case 'SEM_USO_EPI':
        return 'Sem Uso de EPI';
      case 'ULTRAPASSOU_AREA_RESTRITA':
        return 'Ultrapassou Área Restrita';
      default:
        return alertType.replaceAll('_', ' ');
    }
  }

  IconData get alertTypeIcon {
    switch (alertType.toUpperCase()) {
      case 'SEM_USO_EPI':
        return Icons.warning;
      case 'ULTRAPASSOU_AREA_RESTRITA':
        return Icons.block;
      default:
        return Icons.error_outline;
    }
  }

  Color get alertTypeColor {
    switch (alertType.toUpperCase()) {
      case 'SEM_USO_EPI':
        return Colors.red;
      case 'ULTRAPASSOU_AREA_RESTRITA':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }
}

class StatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  StatusInfo(this.label, this.color, this.icon);
}

class NotificationStatusInfo {
  final String label;
  final Color color;

  NotificationStatusInfo(this.label, this.color);
}
