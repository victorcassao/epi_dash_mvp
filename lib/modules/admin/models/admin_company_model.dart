// lib/modules/admin/models/admin_company_model.dart
class AdminCompanyModel {
  final int? id;
  final String name;
  final String cnpj;
  final bool isActive;

  AdminCompanyModel({
    this.id,
    required this.name,
    required this.cnpj,
    this.isActive = true,
  });

  factory AdminCompanyModel.fromJson(Map<String, dynamic> json) {
    return AdminCompanyModel(
      id: json['id'],
      name: json['name'],
      cnpj: json['cnpj'],
      isActive: json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'cnpj': cnpj,
      'is_active': isActive,
    };
  }

  // Para usar em dropdowns
  @override
  String toString() => name;
}