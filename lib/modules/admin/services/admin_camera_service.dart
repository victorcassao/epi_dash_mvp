// ==========================================
// lib/modules/admin/services/admin_camera_service.dart
// CRIAR ESTE ARQUIVO COMPLETO
// ==========================================

import 'dart:convert';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_camera_model.dart';
import 'package:http/http.dart' as http;

class AdminCameraService {
  final AdminEndpoints endpoints;

  AdminCameraService({required this.endpoints});

  Map<String, String> _buildHeaders(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<AdminCameraModel> createCamera(
      AdminCameraModel camera,
      String token,
      ) async {

    final url = endpoints.createCamera(camera.companyId);

    try {
      final response = await http.post(
        url,
        headers: _buildHeaders(token),
        body: jsonEncode(camera.toJson()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newCamera = AdminCameraModel(
          id: data["id"],
          location: data["location"],
          model: data["model"],
          targetFps: 2,
          companyId: camera.companyId
        );
        return newCamera;
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
}