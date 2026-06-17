import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:postgres/postgres.dart';

// Configuración de PostgreSQL
const dbHost = 'localhost';
const dbPort = 5432;
const dbName = 'SMARTTRAMITES';
const dbUser = 'postgres';
const dbPassword = 'salomon759810'; // ✅ Tu contraseña de PostgreSQL

late Connection connection;

Future<void> main() async {
  try {
    print('🔄 Intentando conectar a PostgreSQL...');
    print('📍 Host: $dbHost:$dbPort');
    print('📦 Database: $dbName');
    print('👤 User: $dbUser');

    // Conectar a PostgreSQL
    connection = await Connection.open(
      Endpoint(
        host: dbHost,
        port: dbPort,
        database: dbName,
        username: dbUser,
        password: dbPassword,
      ),
      settings: ConnectionSettings(
        sslMode: SslMode.disable,
        connectTimeout: Duration(seconds: 10),
      ),
    );

    print('✅ Conectado a PostgreSQL: $dbName');
    print('🔗 Conexión establecida correctamente');
  } catch (e) {
    print('❌ Error al conectar a PostgreSQL: $e');
    print('💡 Verifica:');
    print('   1. PostgreSQL está corriendo (net start | findstr "postgresql")');
    print('   2. La contraseña es correcta');
    print('   3. La base de datos "$dbName" existe');
    print('   4. El usuario "$dbUser" tiene permisos');
    print('\n🔧 Para crear la base de datos, ejecuta en psql:');
    print('   CREATE DATABASE "SMARTTRAMITES";');
    return;
  }

  // Crear router
  final router = Router();

  // Ruta de prueba
  router.get('/health', (Request request) {
    return Response.ok(
        jsonEncode({'status': 'ok', 'message': 'SmartTrámites API v1.0'}));
  });

  // LOGIN
  router.post('/api/auth/login', (Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final email = data['email'];
      final password = data['password'];

      print('🔐 Intento de login para: $email');

      final results = await connection.execute(
        Sql.named(
            'SELECT id, nombres, apellidos, email, password_hash FROM users WHERE email = @email'),
        parameters: {'email': email},
      );

      if (results.isEmpty) {
        print('❌ Usuario no encontrado: $email');
        return Response(401,
            body: jsonEncode({'error': 'Usuario no encontrado'}));
      }

      final user = results.first;
      // ⚠️ En producción usar bcrypt - Por ahora comparación directa
      if (user[3] != password) {
        print('❌ Contraseña incorrecta para: $email');
        return Response(401,
            body: jsonEncode({'error': 'Contraseña incorrecta'}));
      }

      print('✅ Login exitoso: $email');
      return Response.ok(jsonEncode({
        'token': 'token_simulado_${user[0]}',
        'user': {
          'id': user[0],
          'nombres': user[1],
          'apellidos': user[2],
          'email': user[3],
        }
      }));
    } catch (e) {
      print('❌ Error en login: $e');
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // REGISTER
  router.post('/api/auth/register', (Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      print('📝 Registrando usuario: ${data['email']}');

      // Verificar si el email ya existe
      final existingEmail = await connection.execute(
        Sql.named('SELECT id FROM users WHERE email = @email'),
        parameters: {'email': data['email']},
      );

      if (existingEmail.isNotEmpty) {
        print('❌ Email ya registrado: ${data['email']}');
        return Response(409,
            body: jsonEncode(
                {'error': 'El correo electrónico ya está registrado'}));
      }

      // Verificar si el CI ya existe
      final existingCI = await connection.execute(
        Sql.named(
            'SELECT id FROM users WHERE numero_documento = @num_doc AND lugar_expedicion = @lugar_exp'),
        parameters: {
          'num_doc': data['numeroDocumento'],
          'lugar_exp': data['lugarExpedicion']
        },
      );

      if (existingCI.isNotEmpty) {
        print('❌ CI ya registrado: ${data['numeroDocumento']}');
        return Response(409,
            body: jsonEncode(
                {'error': 'Este número de documento ya está registrado'}));
      }

      final result = await connection.execute(
        Sql.named('''INSERT INTO users 
           (tipo_documento, numero_documento, lugar_expedicion, nombres, apellidos, 
            fecha_nacimiento, telefono, email, password_hash, genero, estado_civil, 
            profesion, direccion)
           VALUES (@tipo_doc, @num_doc, @lugar_exp, @nombres, @apellidos,
                   @fecha_nac, @telefono, @email, @password, @genero, @estado_civil,
                   @profesion, @direccion)
           RETURNING id, nombres, apellidos, email'''),
        parameters: {
          'tipo_doc': data['tipoDocumento'] ?? 'CI',
          'num_doc': data['numeroDocumento'],
          'lugar_exp': data['lugarExpedicion'],
          'nombres': data['nombres'],
          'apellidos': data['apellidos'],
          'fecha_nac': data['fechaNacimiento'],
          'telefono': data['telefono'],
          'email': data['email'],
          'password': data['password'],
          'genero': data['genero'],
          'estado_civil': data['estadoCivil'],
          'profesion': data['profesion'] ?? '',
          'direccion': data['direccion'] ?? '',
        },
      );

      final user = result.first;
      print('✅ Usuario registrado exitosamente: ${user[3]}');

      return Response.ok(jsonEncode({
        'token': 'token_simulado_${user[0]}',
        'user': {
          'id': user[0],
          'nombres': user[1],
          'apellidos': user[2],
          'email': user[3],
        }
      }));
    } catch (e) {
      print('❌ Error en registro: $e');
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // 🆕 POST CREAR USUARIO DIRECTO (para DatabaseService)
  router.post('/api/users', (Request request) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      print('📝 Creando usuario directo: ${data['email']}');

      // Verificar si el email ya existe
      final existingEmail = await connection.execute(
        Sql.named('SELECT id FROM users WHERE email = @email'),
        parameters: {'email': data['email']},
      );

      if (existingEmail.isNotEmpty) {
        print('❌ Email ya registrado: ${data['email']}');
        return Response(409,
            body: jsonEncode(
                {'error': 'El correo electrónico ya está registrado'}));
      }

      // Verificar si el CI ya existe
      if (data['numeroDocumento'] != null && data['lugarExpedicion'] != null) {
        final existingCI = await connection.execute(
          Sql.named(
              'SELECT id FROM users WHERE numero_documento = @num_doc AND lugar_expedicion = @lugar_exp'),
          parameters: {
            'num_doc': data['numeroDocumento'],
            'lugar_exp': data['lugarExpedicion']
          },
        );

        if (existingCI.isNotEmpty) {
          print('❌ CI ya registrado: ${data['numeroDocumento']}');
          return Response(409,
              body: jsonEncode(
                  {'error': 'Este número de documento ya está registrado'}));
        }
      }

      final result = await connection.execute(
        Sql.named('''INSERT INTO users 
           (tipo_documento, numero_documento, complemento, lugar_expedicion, nombres, apellidos, 
            fecha_nacimiento, telefono, email, password_hash, genero, estado_civil, 
            profesion, direccion, esta_verificado)
           VALUES (@tipo_doc, @num_doc, @complemento, @lugar_exp, @nombres, @apellidos,
                   @fecha_nac, @telefono, @email, @password, @genero, @estado_civil,
                   @profesion, @direccion, @verificado)
           RETURNING id, nombres, apellidos, email'''),
        parameters: {
          'tipo_doc': data['tipoDocumento'] ?? 'CI',
          'num_doc': data['numeroDocumento'],
          'complemento': data['complemento'],
          'lugar_exp': data['lugarExpedicion'],
          'nombres': data['nombres'],
          'apellidos': data['apellidos'],
          'fecha_nac': data['fechaNacimiento'],
          'telefono': data['telefono'],
          'email': data['email'],
          'password': data['password'],
          'genero': data['genero'] ?? '',
          'estado_civil': data['estadoCivil'] ?? '',
          'profesion': data['profesion'] ?? '',
          'direccion': data['direccion'] ?? '',
          'verificado': data['estaVerificado'] ?? false,
        },
      );

      final user = result.first;
      print('✅ Usuario creado exitosamente: ${user[3]}');

      return Response.ok(jsonEncode({
        'success': true,
        'user': {
          'id': user[0],
          'nombres': user[1],
          'apellidos': user[2],
          'email': user[3],
        }
      }));
    } catch (e) {
      print('❌ Error creando usuario: $e');
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // 🆕 PUT ACTUALIZAR USUARIO
  router.put('/api/users/<id>', (Request request, String id) async {
    try {
      final body = await request.readAsString();
      final data = jsonDecode(body);

      print('🔄 Actualizando usuario: $id');

      await connection.execute(
        Sql.named('''UPDATE users SET
           telefono = @telefono,
           profesion = @profesion,
           direccion = @direccion,
           esta_verificado = @verificado
           WHERE id = @id'''),
        parameters: {
          'id': id,
          'telefono': data['telefono'],
          'profesion': data['profesion'] ?? '',
          'direccion': data['direccion'] ?? '',
          'verificado': data['estaVerificado'] ?? false,
        },
      );

      print('✅ Usuario actualizado: $id');
      return Response.ok(jsonEncode({'success': true}));
    } catch (e) {
      print('❌ Error actualizando usuario: $e');
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET USUARIO POR ID
  router.get('/api/users/<id>', (Request request, String id) async {
    try {
      final results = await connection.execute(
        Sql.named(
            'SELECT id, nombres, apellidos, email, telefono, profesion, direccion, fecha_nacimiento, genero, estado_civil FROM users WHERE id = @id'),
        parameters: {'id': id},
      );

      if (results.isEmpty) {
        return Response(404,
            body: jsonEncode({'error': 'Usuario no encontrado'}));
      }

      final user = results.first;
      return Response.ok(jsonEncode({
        'id': user[0],
        'nombres': user[1],
        'apellidos': user[2],
        'email': user[3],
        'telefono': user[4],
        'profesion': user[5],
        'direccion': user[6],
        'fechaNacimiento': user[7],
        'genero': user[8],
        'estadoCivil': user[9],
      }));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET USUARIO POR EMAIL
  router.get('/api/users/email/<email>', (Request request, String email) async {
    try {
      final results = await connection.execute(
        Sql.named(
            'SELECT id, nombres, apellidos, email, telefono, profesion, direccion FROM users WHERE email = @email'),
        parameters: {'email': email},
      );

      if (results.isEmpty) {
        return Response(404,
            body: jsonEncode({'error': 'Usuario no encontrado'}));
      }

      final user = results.first;
      return Response.ok(jsonEncode({
        'id': user[0],
        'nombres': user[1],
        'apellidos': user[2],
        'email': user[3],
        'telefono': user[4],
        'profesion': user[5],
        'direccion': user[6],
      }));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // 🆕 GET USUARIO POR CI (NUEVO ENDPOINT AGREGADO)
  router.get('/api/users/ci/<ci>', (Request request, String ci) async {
    try {
      final results = await connection.execute(
        Sql.named(
            'SELECT id, nombres, apellidos, email, telefono, profesion, direccion, tipo_documento, numero_documento, lugar_expedicion FROM users WHERE numero_documento = @ci'),
        parameters: {'ci': ci},
      );

      if (results.isEmpty) {
        return Response(404,
            body: jsonEncode({'error': 'Usuario no encontrado'}));
      }

      final user = results.first;
      return Response.ok(jsonEncode({
        'id': user[0],
        'nombres': user[1],
        'apellidos': user[2],
        'email': user[3],
        'telefono': user[4],
        'profesion': user[5],
        'direccion': user[6],
        'tipoDocumento': user[7],
        'numeroDocumento': user[8],
        'lugarExpedicion': user[9],
      }));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET TRÁMITES POR USUARIO
  router.get('/api/tramites/user/<userId>',
      (Request request, String userId) async {
    try {
      final results = await connection.execute(
        Sql.named('''SELECT t.id, t.nombre, t.estado, t.costo, t.fecha_creacion,
                e.nombre as entidad_nombre
         FROM tramites t
         LEFT JOIN entidades e ON t.entidad_id = e.id
         WHERE t.usuario_id = @userId
         ORDER BY t.fecha_creacion DESC'''),
        parameters: {'userId': userId},
      );

      final tramites = results
          .map((r) => {
                'id': r[0],
                'nombre': r[1],
                'estado': r[2],
                'costo': r[3],
                'fecha_creacion': r[4],
                'entidad': r[5],
              })
          .toList();

      return Response.ok(jsonEncode(tramites));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // CREAR TRÁMITE
  router.post('/api/tramites', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    try {
      await connection.execute(
        Sql.named(
            '''INSERT INTO tramites (usuario_id, entidad_id, nombre, descripcion, costo, estado)
           VALUES (@userId, @entidadId, @nombre, @descripcion, @costo, 'pendiente')'''),
        parameters: {
          'userId': data['usuario_id'],
          'entidadId': data['entidad_id'],
          'nombre': data['nombre'],
          'descripcion': data['descripcion'] ?? '',
          'costo': data['costo'] ?? 0,
        },
      );
      return Response.ok(jsonEncode({'success': true}));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET COMPROBANTES POR USUARIO
  router.get('/api/pagos/user/<userId>',
      (Request request, String userId) async {
    try {
      final results = await connection.execute(
        Sql.named('''SELECT id, tramite_id, entidad, concepto, monto, moneda, 
                metodo_pago, fecha_emision, estado, referencia_bancaria
         FROM pagos
         WHERE usuario_id = @userId
         ORDER BY fecha_emision DESC'''),
        parameters: {'userId': userId},
      );

      final comprobantes = results
          .map((r) => {
                'id': r[0],
                'tramiteId': r[1],
                'entidad': r[2],
                'concepto': r[3],
                'monto': r[4],
                'moneda': r[5],
                'metodoPago': r[6],
                'fechaEmision': r[7],
                'estado': r[8],
                'referenciaBancaria': r[9],
              })
          .toList();

      return Response.ok(jsonEncode(comprobantes));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // CREAR PAGO/COMPROBANTE
  router.post('/api/pagos', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    try {
      await connection.execute(
        Sql.named('''INSERT INTO pagos 
           (tramite_id, usuario_id, entidad, concepto, monto, moneda, 
            metodo_pago, qr_code_data, referencia_bancaria, estado)
           VALUES (@tramiteId, @userId, @entidad, @concepto, @monto, @moneda,
                   @metodoPago, @qrCodeData, @referencia, @estado)'''),
        parameters: {
          'tramiteId': data['tramite_id'],
          'userId': data['usuario_id'],
          'entidad': data['entidad'],
          'concepto': data['concepto'],
          'monto': data['monto'],
          'moneda': data['moneda'] ?? 'BOB',
          'metodoPago': data['metodo_pago'],
          'qrCodeData': data['qr_code_data'],
          'referencia': data['referencia_bancaria'],
          'estado': data['estado'] ?? 'pagado',
        },
      );
      return Response.ok(jsonEncode({'success': true}));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // GET RECORDATORIOS POR USUARIO
  router.get('/api/recordatorios/user/<userId>',
      (Request request, String userId) async {
    try {
      String query = '''SELECT id, titulo, tramite_nombre, fecha, completado
         FROM recordatorios
         WHERE usuario_id = @userId''';

      final completado = request.requestedUri.queryParameters['completado'];
      if (completado != null) {
        query += ' AND completado = ${completado == 'true' ? 'TRUE' : 'FALSE'}';
      }

      query += ' ORDER BY fecha ASC';

      final results = await connection.execute(
        Sql.named(query),
        parameters: {'userId': userId},
      );

      final recordatorios = results
          .map((r) => {
                'id': r[0],
                'titulo': r[1],
                'tramiteNombre': r[2],
                'fecha': r[3],
                'completado': r[4],
              })
          .toList();

      return Response.ok(jsonEncode(recordatorios));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // CREAR RECORDATORIO
  router.post('/api/recordatorios', (Request request) async {
    final body = await request.readAsString();
    final data = jsonDecode(body);

    try {
      await connection.execute(
        Sql.named('''INSERT INTO recordatorios 
           (usuario_id, titulo, tramite_nombre, fecha, completado)
           VALUES (@userId, @titulo, @tramiteNombre, @fecha, FALSE)'''),
        parameters: {
          'userId': data['usuario_id'],
          'titulo': data['titulo'],
          'tramiteNombre': data['tramite_nombre'],
          'fecha': data['fecha'],
        },
      );
      return Response.ok(jsonEncode({'success': true}));
    } catch (e) {
      return Response(500, body: jsonEncode({'error': e.toString()}));
    }
  });

  // Pipeline con CORS
  final handler = const Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(_corsHeaders())
      .addHandler(router.call);

  // Iniciar servidor
  final server = await io.serve(handler, 'localhost', 8080);
  print('🚀 Servidor corriendo en http://localhost:${server.port}');
  print('📡 Endpoints disponibles:');
  print('   - GET  /health');
  print('   - POST /api/auth/login');
  print('   - POST /api/auth/register');
  print('   - POST /api/users'); // 🆕 NUEVO
  print('   - PUT  /api/users/<id>'); // 🆕 NUEVO
  print('   - GET  /api/users/<id>');
  print('   - GET  /api/users/email/<email>');
  print('   - GET  /api/users/ci/<ci>'); // 🆕 NUEVO
  print('   - GET  /api/tramites/user/<userId>');
  print('   - POST /api/tramites');
  print('   - GET  /api/pagos/user/<userId>');
  print('   - POST /api/pagos');
  print('   - GET  /api/recordatorios/user/<userId>');
  print('   - POST /api/recordatorios');
  print('\n✅ Backend listo para recibir solicitudes');
}

Middleware _corsHeaders() {
  return (Handler handler) {
    return (Request request) async {
      // Manejar preflight OPTIONS
      if (request.method == 'OPTIONS') {
        return Response.ok('', headers: {
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
          'Access-Control-Allow-Headers': 'Content-Type, Authorization',
        });
      }

      final response = await handler(request);
      return response.change(headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
        'Access-Control-Allow-Headers': 'Content-Type, Authorization',
      });
    };
  };
}
