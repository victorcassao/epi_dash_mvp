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

  // ✅ FromJson alinhado com a resposta da API
  factory AdminCompanyModel.fromJson(Map<String, dynamic> json) {
    return AdminCompanyModel(
      id: json['id'] as int?,
      name: json['name'] as String,
      cnpj: json['cnpj'] as String,
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  // ✅ ToJson para enviar na request (apenas name e cnpj)
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cnpj': cnpj,
      // Não envia is_active na criação, apenas name e cnpj
    };
  }

  // ✅ ToJson completo (caso precise em outros contextos)
  Map<String, dynamic> toJsonComplete() {
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