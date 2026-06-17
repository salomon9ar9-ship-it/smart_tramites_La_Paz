import '../models/user_model.dart';
import '../services/database_service.dart';
import '../services/validation_service.dart';

class UserRepository {
  static final UserRepository _instance = UserRepository._internal();
  factory UserRepository() => _instance;
  UserRepository._internal();

  final _db = DatabaseService.instance;
  final _validation = ValidationService();

  /// 📝 Registrar nuevo usuario
  Future<({bool success, String message, UserModel? user})> registerUser(
      UserModel user) async {
    try {
      // 1. Validar formato
      final errors = _validation.validateUserData(
        tipoDocumento: user.tipoDocumento,
        numeroDocumento: user.numeroDocumento,
        lugarExpedicion: user.lugarExpedicion,
        nombres: user.nombres,
        apellidos: user.apellidos,
        fechaNacimiento: user.fechaNacimiento,
        telefono: user.telefono,
        email: user.email,
        password: user.password,
        complemento: user.complemento,
      );

      if (errors.isNotEmpty) {
        return (
          success: false,
          message: errors.values.first ?? 'Error de validación',
          user: null
        );
      }

      // 2. Verificar duplicados (Email y CI)
      final existingEmail = await _db.getUserByEmail(user.email);
      if (existingEmail != null) {
        return (
          success: false,
          message: 'El correo electrónico ya está registrado.',
          user: null
        );
      }

      final existingCI = await _db.getUserByCI(user.numeroDocumento);
      if (existingCI != null) {
        return (
          success: false,
          message: 'Este número de documento ya existe.',
          user: null
        );
      }

      // 3. Guardar en DB (convertir a Map)
      final success = await _db.insertUser(user.toMap());

      return (
        success: success,
        message: success ? 'Registro exitoso.' : 'Error al guardar.',
        user: success ? user : null
      );
    } catch (e) {
      return (success: false, message: 'Error interno: $e', user: null);
    }
  }

  /// 🔐 Iniciar sesión por Email
  Future<({bool success, String message, UserModel? user})> loginWithEmail(
      String email, String password) async {
    try {
      final userMap = await _db.getUserByEmail(email);

      if (userMap == null) {
        return (success: false, message: 'Usuario no encontrado.', user: null);
      }

      // Convertir Map a UserModel
      final user = UserModel.fromMap(userMap);

      if (user.password != password) {
        // ⚠️ Recuerda hashear password al comparar
        return (success: false, message: 'Contraseña incorrecta.', user: null);
      }

      return (success: true, message: 'Bienvenido.', user: user);
    } catch (e) {
      return (success: false, message: 'Error al conectar.', user: null);
    }
  }

  /// 🪪 Obtener perfil de usuario
  Future<UserModel?> getUserProfile(String userId) async {
    final userMap = await _db.getUserById(userId);
    if (userMap == null) return null;

    // Convertir Map a UserModel
    return UserModel.fromMap(userMap);
  }

  /// 🔄 Actualizar datos del perfil
  Future<bool> updateProfile(UserModel updatedUser) async {
    // Convertir UserModel a Map
    return await _db.updateUser(updatedUser.toMap());
  }

  /// ✅ Marcar usuario como verificado (post-validación SEGIP/Carnet)
  Future<bool> verifyUser(String userId) async {
    final userMap = await _db.getUserById(userId);
    if (userMap == null) return false;

    // Convertir Map a UserModel
    final user = UserModel.fromMap(userMap);
    final verifiedUser = user.copyWith(estaVerificado: true);

    // Convertir UserModel a Map para actualizar
    return await _db.updateUser(verifiedUser.toMap());
  }
}
