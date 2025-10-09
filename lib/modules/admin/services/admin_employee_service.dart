// ==========================================
// lib/modules/admin/services/admin_employee_service.dart
// CRIAR ESTE ARQUIVO COMPLETO
// ==========================================

import 'dart:convert';
import 'package:epi_dash_mvp/modules/admin/models/admin_employee_model.dart';
import 'package:http/http.dart' as http;

class AdminEmployeeService {
  final String baseUrl;

  AdminEmployeeService({required this.baseUrl});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Criar novo empregado
  Future<AdminEmployeeModel> createEmployee(
      AdminEmployeeModel employee,
      String token,
      ) async {
    // TODO: Implementar quando API estiver pronta
    final url = Uri.parse('$baseUrl/admin/employees');

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(employee.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminEmployeeModel.fromJson(data);
      } else {
        throw Exception('Erro ao criar empregado: ${response.statusCode}');
      }
    } catch (e) {
      // Por enquanto, lança erro enquanto API não existe
      throw UnimplementedError(
          'API endpoint POST /admin/employees não implementado ainda. '
              'Erro original: ${e.toString()}'
      );
    }
  }

  /// Listar todos empregados (opcional para futuro)
  Future<List<AdminEmployeeModel>> fetchAllEmployees(String token) async {
    final url = Uri.parse('$baseUrl/admin/employees');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AdminEmployeeModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar empregados: ${response.statusCode}');
      }
    } catch (e) {
      throw UnimplementedError('API endpoint GET /admin/employees não implementado ainda');
    }
  }

  /// Buscar empregado por ID (opcional para futuro)
  Future<AdminEmployeeModel> fetchEmployeeById(int id, String token) async {
    final url = Uri.parse('$baseUrl/admin/employees/$id');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminEmployeeModel.fromJson(data);
      } else {
        throw Exception('Erro ao buscar empregado: ${response.statusCode}');
      }
    } catch (e) {
      throw UnimplementedError('API endpoint GET /admin/employees/:id não implementado ainda');
    }
  }
}