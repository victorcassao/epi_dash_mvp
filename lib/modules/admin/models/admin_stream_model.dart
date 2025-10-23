import 'package:intl/intl.dart';


class AdminCameraStreamModel {

  final int id;
  final String location;
  final String model;
  final bool isActive;
  final int targetFps;
  final String accessKey;
  final String? streamCurrentStatus;
  final DateTime? streamLastStatusAt;
  final bool shouldStream;
  final int companyId;
  final String companyName;
  final String companyCnpj;
  final bool companyIsActive;

  AdminCameraStreamModel(
      {
        required this.id,
        required this.location,
        required this.model,
        required this.isActive,
        required this.targetFps,
        required this.accessKey,
        required this. streamCurrentStatus,
        required this. streamLastStatusAt,
        required this.shouldStream,
        required this.companyId,
        required this.companyName,
        required this.companyCnpj,
        required this.companyIsActive
      }
      );

  factory AdminCameraStreamModel.fromJson(Map<String, dynamic> json){
    final obj = AdminCameraStreamModel(
        id: json["id"],
        location: json["location"],
        model: json["model"],
        isActive: json["is_active"],
        targetFps: json["target_fps"],
        accessKey: json["access_key"],
        streamCurrentStatus: json["current_status"],
        streamLastStatusAt: json["last_status_at"] != null
            ? DateTime.parse(json["last_status_at"])
            : null,
        shouldStream: json["should_stream"],
        companyId: json["company_id"],
        companyName: json["company_name"],
        companyCnpj: json["company_cnpj"],
        companyIsActive: json["company_is_active"]
    );
    return obj;
  }

  String get formattedLastStatus {
    if (streamLastStatusAt == null) return "-";
    final local = streamLastStatusAt!.toLocal(); // converte UTC para local
    return DateFormat("dd/MM/yyyy HH:mm").format(local);
  }
}

/// Classe auxiliar para encapsular a paginação
class AdminPaginatedStreams {
  final List<AdminCameraStreamModel> items;
  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  AdminPaginatedStreams({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory AdminPaginatedStreams.fromJson(Map<String, dynamic> json) {

    final items = (json["items"] as List)
        .map((e) => AdminCameraStreamModel.fromJson(e))
        .toList();
    final paginatedResponse = AdminPaginatedStreams(
      items: items,
      page: json["page"],
      pageSize: json["page_size"],
      totalItems: json["total_items"],
      totalPages: json["total_pages"],
    );
    return paginatedResponse;
  }
}