class AdminEmployeeModel {
  final int? id;
  final String name;
  final String email;
  final String username;
  final String password;
  final String? role; // ✅ Agora opcional, vem da resposta mas não vai no request
  final int companyId;

  AdminEmployeeModel({
    this.id,
    required this.name,
    required this.email,
    required this.username,
    required this.password,
    this.role,
    required this.companyId,
  });

  /// Criar modelo a partir de JSON (resposta da API)
  /// A resposta inclui: id, role, user{name, username, email, is_active}, company{id, name, cnpj, is_active}
  factory AdminEmployeeModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;

    return AdminEmployeeModel(
      id: json['id'] as int?,
      name: user?['name'] as String? ?? '',
      email: user?['email'] as String? ?? '',
      username: user?['username'] as String? ?? '',
      password: '', // Não retorna senha do backend por segurança
      role: json['role'] as String?,
      companyId: json['company']?['id'] as int? ?? 0,
    );
  }

  /// Converter modelo para JSON (enviar para API)
  /// Request body: apenas name, username, email, password
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'username': username,
      'email': email,
      'password': password,
      // ✅ NÃO envia role no request
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