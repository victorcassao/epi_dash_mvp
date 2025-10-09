class AdminCameraModel {
  final int? id;
  final String location;
  final String model;
  final bool isActive;
  final int companyId;
  final int targetFps;

  AdminCameraModel({
    this.id,
    required this.location,
    required this.model,
    this.isActive = true,
    required this.companyId,
    this.targetFps = 30,
  });

  /// Criar modelo a partir de JSON (resposta da API)
  factory AdminCameraModel.fromJson(Map<String, dynamic> json) {
    return AdminCameraModel(
      id: json['id'],
      location: json['location'],
      model: json['model'],
      isActive: json['is_active'] ?? true,
      companyId: json['company_id'],
      targetFps: json['target_fps'] ?? 30,
    );
  }

  /// Converter modelo para JSON (enviar para API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'location': location,
      'model': model,
      'is_active': isActive,
      'company_id': companyId,
      'target_fps': targetFps,
    };
  }

  /// Cópia com modificações
  AdminCameraModel copyWith({
    int? id,
    String? location,
    String? model,
    bool? isActive,
    int? companyId,
    int? targetFps,
  }) {
    return AdminCameraModel(
      id: id ?? this.id,
      location: location ?? this.location,
      model: model ?? this.model,
      isActive: isActive ?? this.isActive,
      companyId: companyId ?? this.companyId,
      targetFps: targetFps ?? this.targetFps,
    );
  }

  @override
  String toString() => 'AdminCameraModel(id: $id, location: $location, model: $model, isActive: $isActive, companyId: $companyId, targetFps: $targetFps)';
}