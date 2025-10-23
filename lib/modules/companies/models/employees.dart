enum EmployeeRole {
  manager('MANAGER', 'Gerente'),
  viewer('VIEWER', 'Operador');

  final String value;
  final String displayName;

  const EmployeeRole(this.value, this.displayName);

  static EmployeeRole fromString(String value) {
    return EmployeeRole.values.firstWhere(
          (role) => role.value == value,
      orElse: () => EmployeeRole.viewer,
    );
  }
}
