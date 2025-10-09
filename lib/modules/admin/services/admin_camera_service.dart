// ==========================================
// lib/modules/admin/services/admin_camera_service.dart
// CRIAR ESTE ARQUIVO COMPLETO
// ==========================================

import 'dart:convert';
import 'package:epi_dash_mvp/modules/admin/models/admin_camera_model.dart';
import 'package:http/http.dart' as http;

class AdminCameraService {
  final String baseUrl;

  AdminCameraService({required this.baseUrl});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  /// Criar nova câmera
  Future<AdminCameraModel> createCamera(
      AdminCameraModel camera,
      String token,
      ) async {
    // TODO: Implementar quando API estiver pronta
    final url = Uri.parse('$baseUrl/admin/cameras');

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(camera.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminCameraModel.fromJson(data);
      } else {
        throw Exception('Erro ao criar câmera: ${response.statusCode}');
      }
    } catch (e) {
      // Por enquanto, lança erro enquanto API não existe
      throw UnimplementedError(
          'API endpoint POST /admin/cameras não implementado ainda. '
              'Erro original: ${e.toString()}'
      );
    }
  }

  /// Listar todas câmeras (opcional para futuro)
  Future<List<AdminCameraModel>> fetchAllCameras(String token) async {
    final url = Uri.parse('$baseUrl/admin/cameras');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AdminCameraModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar câmeras: ${response.statusCode}');
      }
    } catch (e) {
      throw UnimplementedError('API endpoint GET /admin/cameras não implementado ainda');
    }
  }

  /// Buscar câmera por ID (opcional para futuro)
  Future<AdminCameraModel> fetchCameraById(int id, String token) async {
    final url = Uri.parse('$baseUrl/admin/cameras/$id');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return AdminCameraModel.fromJson(data);
      } else {
        throw Exception('Erro ao buscar câmera: ${response.statusCode}');
      }
    } catch (e) {
      throw UnimplementedError('API endpoint GET /admin/cameras/:id não implementado ainda');
    }
  }

  /// Buscar câmeras por empresa (opcional para futuro)
  Future<List<AdminCameraModel>> fetchCamerasByCompany(
      int companyId,
      String token,
      ) async {
    final url = Uri.parse('$baseUrl/admin/companies/$companyId/cameras');

    try {
      final response = await http.get(
        url,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => AdminCameraModel.fromJson(json)).toList();
      } else {
        throw Exception('Erro ao carregar câmeras: ${response.statusCode}');
      }
    } catch (e) {
      throw UnimplementedError('API endpoint GET /admin/companies/:id/cameras não implementado ainda');
    }
  }
}