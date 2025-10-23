import 'dart:convert';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:epi_dash_mvp/modules/alerts/models/alert_model.dart';
import 'package:http/http.dart' as http;

class AlertService {
  final UserEndpoints endpoints;

  AlertService({required this.endpoints});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Busca todos os alertas de uma empresa
  Future<List<AlertModel>> fetchCompanyAlerts({
    required int companyId,
    required String token,
    int page = 1,
    int pageSize = 100,
  }) async {
    final url = endpoints.companyAlerts(companyId, page: page, pageSize: pageSize);

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['items'];
        return list.map((e) => AlertModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao carregar alertas: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar alertas: ${e.toString()}');
    }
  }

  /// Busca alertas de uma câmera específica
  Future<List<AlertModel>> fetchCameraAlerts({
    required int companyId,
    required int cameraId,
    required String token,
    int page = 1,
    int pageSize = 100,
  }) async {
    final url = endpoints.cameraAlerts(
      companyId,
      cameraId,
      page: page,
      pageSize: pageSize,
    );

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        final List list = body['items'];
        return list.map((e) => AlertModel.fromJson(e)).toList();
      } else {
        throw Exception('Erro ao carregar alertas da câmera: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erro ao carregar alertas da câmera: ${e.toString()}');
    }
  }
}
