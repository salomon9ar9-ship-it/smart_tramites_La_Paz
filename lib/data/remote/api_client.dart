import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../config/constants.dart';
import '../local/preferences.dart';

/// Excepción estructurada para errores de API
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final Map<String, dynamic>? details;

  ApiException(this.message, {this.statusCode, this.details});

  @override
  String toString() => 'ApiException [$statusCode]: $message';
}

/// Cliente HTTP unificado con interceptores automáticos
class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  final http.Client _http = http.Client();
  final Preferences _prefs = Preferences();

  String get baseUrl => AppConstants.baseUrl;
  Duration get timeout => AppConstants.apiTimeout;

  // 🔥 CORRECCIÓN: Headers base como getter síncrono
  Map<String, String> get _baseHeaders => {
    'Content-Type': 'application/json; charset=utf-8',
    'Accept': 'application/json',
    'X-App-Name': AppConstants.appName,
    'X-App-Version': AppConstants.appVersion,
  };

  // 🔥 CORRECCIÓN: Método async para headers con token (NO getter async)
  Future<Map<String, String>> _getHeaders() async {
    final h = Map<String, String>.from(_baseHeaders);
    final token = _prefs.token;
    if (token != null && token.isNotEmpty) {
      h['Authorization'] = 'Bearer $token';
    }
    return h;
  }

  Future<T> _parse<T>(http.Response res, T Function(dynamic) mapper) async {
    final body = res.body.isEmpty ? null : jsonDecode(res.body);

    if (res.statusCode >= 200 && res.statusCode < 300) {
      return mapper(body);
    } else if (res.statusCode == 401) {
      await _prefs.clearAuth();
      throw ApiException('Sesión expirada. Inicia sesión nuevamente.', statusCode: 401);
    } else if (res.statusCode == 400) {
      final msg = body is Map ? body['message'] ?? 'Error de validación' : 'Error de validación';
      throw ApiException(msg.toString(), statusCode: 400, details: body);
    } else if (res.statusCode == 403) {
      throw ApiException('Permiso denegado.', statusCode: 403);
    } else if (res.statusCode == 404) {
      throw ApiException('Recurso no encontrado.', statusCode: 404);
    } else if (res.statusCode >= 500) {
      throw ApiException('Error del servidor. Intenta más tarde.', statusCode: res.statusCode);
    } else {
      throw ApiException('Error inesperado (${res.statusCode})', statusCode: res.statusCode);
    }
  }

  Future<T> _request<T>(
    Future<http.Response> Function() req,
    T Function(dynamic) mapper,
  ) async {
    try {
      final res = await req().timeout(timeout);
      return _parse(res, mapper);
    } on SocketException {
      throw ApiException('Sin conexión a internet. Verifica tu red.');
    } on TimeoutException {
      throw ApiException('Tiempo de espera agotado. Servidor lento.');
    } on FormatException {
      throw ApiException('Respuesta del servidor inválida.');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Error de red: ${e.toString()}');
    }
  }

  // ─────────────────────────────────────────────────────
  // 🌐 MÉTODOS HTTP (GET, POST, PUT, PATCH, DELETE)
  // ─────────────────────────────────────────────────────

  Future<T> get<T>(String path, {required T Function(dynamic) mapper}) async {
    final headers = await _getHeaders();
    return _request(
      () => _http.get(Uri.parse('$baseUrl$path'), headers: headers),
      mapper,
    );
  }

  Future<T> post<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic) mapper,
  }) async {
    final headers = await _getHeaders();
    return _request(
      () => _http.post(
        Uri.parse('$baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
      mapper,
    );
  }

  Future<T> put<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic) mapper,
  }) async {
    final headers = await _getHeaders();
    return _request(
      () => _http.put(
        Uri.parse('$baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
      mapper,
    );
  }

  Future<T> patch<T>(
    String path, {
    Map<String, dynamic>? body,
    required T Function(dynamic) mapper,
  }) async {
    final headers = await _getHeaders();
    return _request(
      () => _http.patch(
        Uri.parse('$baseUrl$path'),
        headers: headers,
        body: body != null ? jsonEncode(body) : null,
      ),
      mapper,
    );
  }

  Future<T> delete<T>(
    String path, {
    required T Function(dynamic) mapper,
  }) async {
    final headers = await _getHeaders();
    return _request(
      () => _http.delete(Uri.parse('$baseUrl$path'), headers: headers),
      mapper,
    );
  }

  /// Cierra el cliente HTTP (útil para testing o shutdown)
  void dispose() => _http.close();
}