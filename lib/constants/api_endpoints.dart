class AuthEndpoints {
  final String baseUrl;

  AuthEndpoints(this.baseUrl);

  /// POST /authentication/user
  Uri get login => Uri.parse('$baseUrl/authentication/user');

  /// GET /me
  Uri get me => Uri.parse('$baseUrl/me');
}

class AdminEndpoints {

  final String baseUrl;

  AdminEndpoints(this.baseUrl);

  // Uri get companies => Uri.parse('$baseUrl/admin/company');
  Uri companies({int page = 1, int pageSize = 100}){
    return Uri.parse('$baseUrl/admin/company').replace(
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
  }

  Uri get createCompany => Uri.parse('$baseUrl/admin/company');

  Uri streams({int page = 1, int pageSize = 100}) {
    return Uri.parse('$baseUrl/admin/streams').replace(
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
  }

  Uri streamById(int streamId) => Uri.parse('$baseUrl/admin/streams/$streamId');

  Uri createCamera(int companyId) =>
      Uri.parse('$baseUrl/company/$companyId/cameras');

  Uri createEmployee(int companyId) =>
      Uri.parse('$baseUrl/company/$companyId/employee');
}

class UserEndpoints {
  final String baseUrl;

  UserEndpoints(this.baseUrl);

  Uri streams(int companyId, {int page = 1, int pageSize = 100}) {
    return Uri.parse('$baseUrl/company/$companyId/streams').replace(
      queryParameters: {
        'page': page.toString(),
        'page_size': pageSize.toString(),
      },
    );
  }

  Uri streamById(int companyId, int streamId) =>
      Uri.parse('$baseUrl/company/$companyId/streams/$streamId');
}

class HlsEndpoints {
  final String baseUrl;

  HlsEndpoints(this.baseUrl);

  Uri liveStream(String accessKey) =>
      Uri.parse('$baseUrl/live/$accessKey/index.m3u8');

  Uri processedStream(String accessKey) =>
      Uri.parse('$baseUrl/processed/$accessKey/index.m3u8');
}
