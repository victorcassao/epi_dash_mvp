import 'dart:convert';
import 'package:epi_dash_mvp/auth/models/user_profile_model.dart';
import 'package:epi_dash_mvp/constants/api_endpoints.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AuthService {
  final AuthEndpoints endpoints;

  AuthService({required this.endpoints});

  Future<String> login({
    required String username,
    required String password,
  }) async {
    final url = endpoints.login;
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      final token = body['access_token'];
      if (token != null) {
        final decoded = JwtDecoder.decode(token);
        final isSuperuser = decoded["is_superuser"] == true;
        if (isSuperuser) {
          throw Exception('Superusuários não podem acessar este portal.');
        }
        return token;
      } else {
        throw Exception('Token não encontrado na resposta.');
      }
    } else {
      throw Exception('Erro de login: ${response.body}');
    }
  }

  Future<UserProfile> getCurrentUserProfile(String token) async {
    final url = endpoints.me;

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      }
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserProfile.fromUserJson(data);
    } else{
      throw Exception('Erro ao carregar usuário: ${response.body}');
    }
  }
}
