import 'dart:convert';
import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:http/http.dart' as http;

class AdminStreamService {
  final String baseUrl;

  AdminStreamService({required this.baseUrl});

  Map<String, String> _buildAndGetHeader(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<List<AdminStreamModel>> fetchAllStreams(String token) async {
    final url = Uri.parse('$baseUrl/admin/streams?page=1&page_size=100');
    final response = await http.get(
        url,
        headers: _buildAndGetHeader(token)
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List list = body['items'];
      return list.map((e) => AdminStreamModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar streams: ${response.body}');
    }
  }

  Future<AdminStreamModel> fetchAdminStreamDetail(String token, int streamId) async {
    final url = Uri.parse('$baseUrl/admin/streams/$streamId');
    final response = await http.get(
      url,
      headers: _buildAndGetHeader(token)
    );
    final body = jsonDecode(response.body);
    return AdminStreamModel.fromJson(body);
  }

}
