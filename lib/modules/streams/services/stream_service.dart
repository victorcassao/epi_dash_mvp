import 'dart:convert';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import '../models/stream_model.dart';

class StreamService {
  final UserEndpoints endpoints;

  StreamService({required this.endpoints});

  Map<String, String> _buildAndGetHeader(String token) {
    return {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
  }
  
  Future<CameraStreamModel> fetchStreamDetail(
      int companyId,
      int streamId,
      String token
      ) async {

    final url = endpoints.streamById(companyId, streamId);
    final response = await http.get(
      url,
      headers: _buildAndGetHeader(token)
    );
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return CameraStreamModel.fromJson(body);
    } else {
      throw Exception('Erro ao carregar streams: ${response.body}');
    }
  }

  Future<List<CameraStreamModel>> fetchAllStreamsByCompanyId(int companyId, String token) async {
    final url = endpoints.streams(companyId);
    final response = await http.get(
      url,
      headers: _buildAndGetHeader(token)
    );
    // print(url);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      // print(body);
      final List list = body['items'];
      final retorno = list.map((e) => CameraStreamModel.fromJson(e)).toList();
      return retorno;
    } else {
      throw Exception('Erro ao carregar streams: ${response.body}');
    }
  }
}
