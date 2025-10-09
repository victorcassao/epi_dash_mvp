import 'package:intl/intl.dart';


class AdminStreamModel {

  final int cameraId;
  final String cameraLocation;
  final bool cameraIsActive;
  final int streamId;
  final int streamTargetFps;
  final String streamAccessKey;
  final String? streamCurrentStatus;
  final DateTime? streamLastStatusAt;
  final bool streamShouldStream;
  final int companyId;
  final String companyName;
  final String companyCnpj;
  final bool companyIsActive;

  AdminStreamModel(
      {
        required this.cameraId,
        required this.cameraLocation,
        required this.cameraIsActive,
        required this.streamId,
        required this.streamTargetFps,
        required this.streamAccessKey,
        required this. streamCurrentStatus,
        required this. streamLastStatusAt,
        required this.streamShouldStream,
        required this.companyId,
        required this.companyName,
        required this.companyCnpj,
        required this.companyIsActive
      }
      );

  factory AdminStreamModel.fromJson(Map<String, dynamic> json){
    final obj = AdminStreamModel(
        cameraId: json["camera_id"],
        cameraLocation: json["camera_location"],
        cameraIsActive: json["camera_is_active"],
        streamId: json["stream_id"],
        streamTargetFps: json["stream_target_fps"],
        streamAccessKey: json["stream_access_key"],
        streamCurrentStatus: json["stream_current_status"],
        streamLastStatusAt: json["stream_last_status_at"] != null
            ? DateTime.parse(json["stream_last_status_at"])
            : null,
        streamShouldStream: json["stream_should_stream"],
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
  final List<AdminStreamModel> items;
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
        .map((e) => AdminStreamModel.fromJson(e))
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