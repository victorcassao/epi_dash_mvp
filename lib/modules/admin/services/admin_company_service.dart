// lib/modules/admin/services/admin_company_service.dart
import 'dart:convert';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:http/http.dart' as http;

class AdminCompanyService {
  final AdminEndpoints endpoints;

  AdminCompanyService({required this.endpoints});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AdminCompanyModel>> fetchAllCompanies(String token) async {
    // final url = AdminEndpoints.listCompanies(baseUrl, pageSize: 100);
    final url = endpoints.companies();

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['items'];
        return list.map((json) => AdminCompanyModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar empresas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar empresas: ${e.toString()}');
    }
  }

  Future<AdminCompanyModel> createCompany(
      AdminCompanyModel company,
      String token,
      ) async {

    final url = endpoints.createCompany;
    try {
      final requestBody = {
        'name': company.name,
        'cnpj': company.cnpj,
      };

      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return AdminCompanyModel.fromJson(data);
      } else if (response.statusCode == 422) {
        // Erro de validação
        final errorData = jsonDecode(response.body);
        throw Exception('Erro de validação: ${errorData['detail']}');
      } else {
        throw Exception('Erro ao criar empresa: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao criar empresa: ${e.toString()}');
    }
  }
}