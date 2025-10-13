// lib/modules/admin/services/admin_company_service.dart
import 'dart:convert';
import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:http/http.dart' as http;

class AdminCompanyService {
  final String baseUrl;

  AdminCompanyService({required this.baseUrl});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AdminCompanyModel>> fetchAllCompanies(String token) async {
    // TODO: Implementar quando API estiver pronta
    final url = Uri.parse('$baseUrl/admin/company');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['items'];
        return list.map((json) => AdminCompanyModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar empresas: ${response.statusCode}');
      }
    } catch (e) {
      // Por enquanto, retorna mock enquanto API não existe
      throw UnimplementedError('API endpoint /admin/companies não implementado ainda');
    }
  }

  Future<AdminCompanyModel> createCompany(
      AdminCompanyModel company,
      String token,
      ) async {
    // TODO: Implementar quando API estiver pronta
    final url = Uri.parse('$baseUrl/admin/companies');

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(company.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminCompanyModel.fromJson(data);
      } else {
        throw Exception('Erro ao criar empresa: ${response.statusCode}');
      }
    } catch (e) {
      // Por enquanto, lança erro enquanto API não existe
      throw UnimplementedError('API endpoint POST /admin/companies não implementado ainda');
    }
  }
}