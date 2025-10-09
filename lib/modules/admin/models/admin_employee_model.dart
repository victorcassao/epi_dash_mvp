class AdminEmployeeModel {
  final int? id;
  final String name;
  final String email;
  final String username;
  final String password;
  final String role;
  final int companyId;

  AdminEmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
    required this.companyId,
  });

  /// Criar modelo a partir de JSON (resposta da API)
  factory AdminEmployeeModel.fromJson(Map<String, dynamic> json) {
    return AdminEmployeeModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      username: json['username'],
      password: '', // Não retorna senha do backend por segurança
      role: json['role'],
      companyId: json['company_id'],
    );
  }

  /// Converter modelo para JSON (enviar para API)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'email': email,
      'username': username,
      'password': password,
      'role': role,
      'company_id': companyId,
    };
  }

  /// Cópia com modificações
  AdminEmployeeModel copyWith({
    int? id,
    String? name,
    String? email,
    String? username,
    String? password,
    String? role,
    int? companyId,
  }) {
    return AdminEmployeeModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      username: username ?? this.username,
      password: password ?? this.password,
      role: role ?? this.role,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  String toString() => 'AdminEmployeeModel(id: $id, name: $name, email: $email, username: $username, role: $role, companyId: $companyId)';
}