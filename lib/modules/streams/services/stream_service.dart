import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stream_model.dart';

class StreamService {
  final String baseUrl;

  StreamService({required this.baseUrl});

  Map<String, String> _buildAndGetHeader(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }

  Future<StreamModel> fetchStreamDetail(
      int companyId,
      int streamId,
      String token
      ) async {
    print("Fetching for $companyId and stream $streamId");
    final url = Uri.parse('$baseUrl/company/$companyId/streams/$streamId');
    final response = await http.get(
      url,
      headers: _buildAndGetHeader(token)
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return StreamModel.fromJson(body);
    } else {
      throw Exception('Erro ao carregar streams: ${response.body}');
    }
  }

  Future<List<StreamModel>> fetchAllStreamsByCompanyId(int companyId, String token) async {
    print("fetching for $companyId");
    final url = Uri.parse('$baseUrl/company/$companyId/streams?page=1&page_size=100');
    final response = await http.get(
      url,
      headers: _buildAndGetHeader(token)
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final List list = body['streams'];
      return list.map((e) => StreamModel.fromJson(e)).toList();
    } else {
      throw Exception('Erro ao carregar streams: ${response.body}');
    }
  }
}
