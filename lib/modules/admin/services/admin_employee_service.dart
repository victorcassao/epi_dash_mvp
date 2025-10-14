// lib/modules/admin/services/admin_employee_service.dart
import 'dart:convert';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_employee_model.dart';
import 'package:http/http.dart' as http;

class AdminEmployeeService {
  final AdminEndpoints endpoints;

  AdminEmployeeService({required this.endpoints});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<AdminEmployeeModel> createEmployee(
      AdminEmployeeModel employee,
      String token,
      ) async {
    // final url = Uri.parse('$baseUrl/company/${employee.companyId}/employee');
    final url = endpoints.createEmployee(employee.companyId);

    try {
      final requestBody = {
        'name': employee.name,
        'username': employee.username,
        'email': employee.email,
        'password': employee.password,
      };

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AdminEmployeeModel.fromJson(data);
      } else if (response.statusCode == 422) {
        // Erro de validação
        final errorData = jsonDecode(response.body);
        throw Exception('Erro de validação: ${errorData['detail']}');
      } else {
        throw Exception('Erro ao criar funcionário: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao criar funcionário: ${e.toString()}');
    }
  }
}
