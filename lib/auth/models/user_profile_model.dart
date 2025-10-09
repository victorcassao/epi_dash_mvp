class CompanyData{

  final int companyId;
  final String name;
  final String cnpj;

  CompanyData(
      {
        required this.companyId,
        required this.name,
        required this.cnpj
      }
      );

  factory CompanyData.fromJson(Map<String, dynamic> data){
    final companyData = CompanyData(
        companyId: data["id"],
        name: data["name"],
        cnpj: data["cnpj"]
    );
    return companyData;
  }
}

class EmployeeData{

  final int employeeId;
  final String role;
  final CompanyData? company;

  EmployeeData(
      {
        required this.employeeId,
        required this.role,
        required this.company
      }
      );

  factory EmployeeData.fromJson(Map<String, dynamic> data){
    final employeeData = EmployeeData(
        employeeId: data["id"],
        role: data["role"],
        company: CompanyData.fromJson(data["company"])
    );
    return employeeData;
  }
}

class UserProfile {
  final int userId;
  final String name;
  final String username;
  final String email;
  final EmployeeData? employee;

  UserProfile(
      {
        required this.userId,
        required this.name,
        required this.username,
        required this.email,
        required this.employee
      }
      );

  factory UserProfile.fromAdminJson(Map<String, dynamic> data){

    final userProfile = UserProfile(
        userId: data["id"],
        name: data["name"],
        username: data["username"],
        email: data["email"],
        employee: null
    );
    return userProfile;
  }

  factory UserProfile.fromUserJson(Map<String, dynamic> data){

    final userProfile = UserProfile(
        userId: data["id"],
        name: data["name"],
        username: data["username"],
        email: data["email"],
        employee: EmployeeData.fromJson(data["employee"])
    );
    return userProfile;
  }
}
