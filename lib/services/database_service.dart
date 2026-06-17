import 'api_service.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._internal();
  factory DatabaseService() => instance;
  DatabaseService._internal();

  final ApiService _api = ApiService();

  static Future<void> initialize() async {
    // Ya no necesita inicialización - usa API HTTP
    print('✅ DatabaseService inicializado (modo API)');
  }

  // ==================== USUARIOS ====================

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    try {
      return await _api.get('/users/email/$email');
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String id) async {
    try {
      return await _api.get('/users/$id');
    } catch (e) {
      print('❌ Error obteniendo usuario: $e');
      return null;
    }
  }

  Future<Map<String, dynamic>?> getUserByCI(String ci) async {
    try {
      // Ajusta el endpoint según tu backend
      return await _api.get('/users/ci/$ci');
    } catch (e) {
      print('❌ Error obteniendo usuario por CI: $e');
      return null;
    }
  }

  Future<bool> insertUser(Map<String, dynamic> user) async {
    try {
      await _api.post('/users', user);
      return true;
    } catch (e) {
      print('❌ Error insertando usuario: $e');
      return false;
    }
  }

  Future<bool> updateUser(Map<String, dynamic> user) async {
    try {
      await _api.put('/users/${user['id']}', user);
      return true;
    } catch (e) {
      print('❌ Error actualizando usuario: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _api.delete('/users/$userId');
      return true;
    } catch (e) {
      print('❌ Error eliminando usuario: $e');
      return false;
    }
  }

  // ==================== TRÁMITES ====================

  Future<List<dynamic>> getTramitesByUser(String usuarioId) async {
    try {
      return await _api.get('/tramites/user/$usuarioId');
    } catch (e) {
      print('❌ Error obteniendo trámites: $e');
      return [];
    }
  }

  Future<bool> insertTramite(Map<String, dynamic> tramite) async {
    try {
      await _api.post('/tramites', tramite);
      return true;
    } catch (e) {
      print('❌ Error insertando trámite: $e');
      return false;
    }
  }

  Future<bool> updateTramiteStatus(String tramiteId, String estado) async {
    try {
      await _api.put('/tramites/$tramiteId', {'estado': estado});
      return true;
    } catch (e) {
      print('❌ Error actualizando trámite: $e');
      return false;
    }
  }

  // ==================== COMPROBANTES ====================

  Future<List<dynamic>> getComprobantesByUser(String usuarioId) async {
    try {
      return await _api.get('/pagos/user/$usuarioId');
    } catch (e) {
      print('❌ Error obteniendo comprobantes: $e');
      return [];
    }
  }

  Future<bool> insertComprobante(Map<String, dynamic> comprobante) async {
    try {
      await _api.post('/pagos', comprobante);
      return true;
    } catch (e) {
      print('❌ Error insertando comprobante: $e');
      return false;
    }
  }

  // ==================== RECORDATORIOS ====================

  Future<void> insertRecordatorio(Map<String, dynamic> recordatorio) async {
    try {
      await _api.post('/recordatorios', recordatorio);
    } catch (e) {
      print('❌ Error insertando recordatorio: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getRecordatoriosByUser(String userId,
      {bool? completado}) async {
    try {
      String endpoint = '/recordatorios/user/$userId';
      if (completado != null) {
        endpoint += '?completado=$completado';
      }
      return await _api.get(endpoint);
    } catch (e) {
      print('❌ Error obteniendo recordatorios: $e');
      return [];
    }
  }

  Future<bool> updateRecordatorio(String id, Map<String, dynamic> data) async {
    try {
      await _api.put('/recordatorios/$id', data);
      return true;
    } catch (e) {
      print('❌ Error actualizando recordatorio: $e');
      return false;
    }
  }

  Future<bool> deleteRecordatorio(String id) async {
    try {
      await _api.delete('/recordatorios/$id');
      return true;
    } catch (e) {
      print('❌ Error eliminando recordatorio: $e');
      return false;
    }
  }

  // ==================== UTILIDADES ====================

  Future<void> close() async {
    // No aplica para API HTTP
  }

  Future<void> clearDatabase() async {
    // No aplica para API HTTP
  }
}
