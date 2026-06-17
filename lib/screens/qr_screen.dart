// lib/screens/qr_screen.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:intl/intl.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';

// ─────────────────────────────────────────────
//  Modelos auxiliares
// ─────────────────────────────────────────────

enum MetodoPago { qrBancario, tarjetaDebito, tarjetaCredito, efectivo }

enum EstadoPago { seleccion, procesando, confirmado, error }

class _MetodoPagoInfo {
  final MetodoPago tipo;
  final String titulo;
  final String subtitulo;
  final IconData icono;
  final Color color;

  const _MetodoPagoInfo({
    required this.tipo,
    required this.titulo,
    required this.subtitulo,
    required this.icono,
    required this.color,
  });
}

// ─────────────────────────────────────────────
//  Pantalla principal
// ─────────────────────────────────────────────

class QrScreen extends StatefulWidget {
  final Tramite tramite;
  const QrScreen({super.key, required this.tramite});

  @override
  State<QrScreen> createState() => _QrScreenState();
}

class _QrScreenState extends State<QrScreen>
    with SingleTickerProviderStateMixin {
  EstadoPago _estado = EstadoPago.seleccion;
  MetodoPago? _metodoPagoSeleccionado;
  late AnimationController _pulseController;
  late DateTime _fechaEmision;
  String? _codigoTransaccion;

  final List<_MetodoPagoInfo> _metodos = const [
    _MetodoPagoInfo(
      tipo: MetodoPago.qrBancario,
      titulo: 'QR Bancario',
      subtitulo: 'Banco Unión · BNB · Banco Fassil',
      icono: Icons.qr_code_2_rounded,
      color: Color(0xFF00B0FF),
    ),
    _MetodoPagoInfo(
      tipo: MetodoPago.tarjetaDebito,
      titulo: 'Tarjeta de Débito',
      subtitulo: 'Visa / Mastercard',
      icono: Icons.credit_card_rounded,
      color: Color(0xFF00C853),
    ),
    _MetodoPagoInfo(
      tipo: MetodoPago.tarjetaCredito,
      titulo: 'Tarjeta de Crédito',
      subtitulo: 'Visa / Mastercard / Amex',
      icono: Icons.payment_rounded,
      color: Color(0xFFFF6D00),
    ),
    _MetodoPagoInfo(
      tipo: MetodoPago.efectivo,
      titulo: 'Pago en Ventanilla',
      subtitulo: 'Presentar código en la entidad',
      icono: Icons.account_balance_rounded,
      color: Color(0xFF7C4DFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fechaEmision = DateTime.now();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String get _qrData {
    return 'SMARTTRAMITES-LAPAZ\n'
        'TRAMITE:${widget.tramite.id.toUpperCase()}\n'
        'NOMBRE:${widget.tramite.nombre}\n'
        'ENTIDAD:${widget.tramite.entidad}\n'
        'COSTO:${widget.tramite.costo}\n'
        'FECHA:${DateFormat('dd/MM/yyyy HH:mm').format(_fechaEmision)}\n'
        'TX:${_codigoTransaccion ?? ''}\n'
        'ESTADO:PENDIENTE_PAGO';
  }

  String get _qrConfirmado {
    return 'SMARTTRAMITES-LAPAZ\n'
        'TRAMITE:${widget.tramite.id.toUpperCase()}\n'
        'NOMBRE:${widget.tramite.nombre}\n'
        'ENTIDAD:${widget.tramite.entidad}\n'
        'COSTO:${widget.tramite.costo}\n'
        'FECHA:${DateFormat('dd/MM/yyyy HH:mm').format(_fechaEmision)}\n'
        'TX:${_codigoTransaccion ?? ''}\n'
        'ESTADO:PAGO_REGISTRADO';
  }

  String _generarCodigoTx() {
    final ts = DateTime.now().millisecondsSinceEpoch.toString();
    return 'ST${ts.substring(ts.length - 8).toUpperCase()}';
  }

  Future<void> _procesarPago() async {
    setState(() {
      _estado = EstadoPago.procesando;
      _codigoTransaccion = _generarCodigoTx();
    });
    // Simulación de procesamiento
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    setState(() => _estado = EstadoPago.confirmado);
    HapticFeedback.mediumImpact();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: _buildAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        transitionBuilder: (child, animation) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
        child: _buildBody(),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    String titulo;
    switch (_estado) {
      case EstadoPago.seleccion:
        titulo = 'Método de Pago';
        break;
      case EstadoPago.procesando:
        titulo = 'Procesando…';
        break;
      case EstadoPago.confirmado:
        titulo = 'Comprobante';
        break;
      case EstadoPago.error:
        titulo = 'Error';
        break;
    }
    return AppBar(
      title: Text(titulo),
      backgroundColor: AppTheme.darkBg,
      leading: _estado == EstadoPago.confirmado
          ? null
          : IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                if (_estado == EstadoPago.procesando) return;
                if (_estado != EstadoPago.seleccion) {
                  setState(() {
                    _estado = EstadoPago.seleccion;
                    _metodoPagoSeleccionado = null;
                  });
                } else {
                  Navigator.pop(context);
                }
              },
            ),
      actions: [
        if (_estado == EstadoPago.seleccion) _buildStepIndicator(1, 3),
        if (_estado == EstadoPago.procesando) _buildStepIndicator(2, 3),
        if (_estado == EstadoPago.confirmado) _buildStepIndicator(3, 3),
      ],
    );
  }

  Widget _buildStepIndicator(int current, int total) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: Text(
          'Paso $current/$total',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_estado) {
      case EstadoPago.seleccion:
        return _buildSeleccion(key: const ValueKey('seleccion'));
      case EstadoPago.procesando:
        return _buildProcesando(key: const ValueKey('procesando'));
      case EstadoPago.confirmado:
        return _buildComprobante(key: const ValueKey('confirmado'));
      case EstadoPago.error:
        return _buildError(key: const ValueKey('error'));
    }
  }

  // ─── PASO 1: Selección de método ───────────────────────────────────────────

  Widget _buildSeleccion({Key? key}) {
    final color = Color(widget.tramite.colorEntidad);
    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Resumen del trámite
          _buildResumenTramite(color),
          const SizedBox(height: 28),

          const Text(
            'Selecciona tu método de pago',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          const Text(
            'Elige cómo deseas realizar el pago del trámite',
            style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),

          ..._metodos
              .asMap()
              .entries
              .map((e) => _buildMetodoCard(e.value, e.key)),

          const SizedBox(height: 24),

          // Botón continuar
          AnimatedOpacity(
            opacity: _metodoPagoSeleccionado != null ? 1.0 : 0.4,
            duration: const Duration(milliseconds: 200),
            child: ElevatedButton(
              onPressed: _metodoPagoSeleccionado != null ? _procesarPago : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.lock_outline, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    _metodoPagoSeleccionado != null
                        ? 'Continuar · ${widget.tramite.costo}'
                        : 'Selecciona un método',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),
          _buildSeguridad(),
        ],
      ),
    );
  }

  Widget _buildResumenTramite(Color color) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.description_outlined, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.tramite.nombre,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.tramite.entidad,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.tramite.costo,
              style: TextStyle(
                  color: color, fontSize: 15, fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.05, end: 0);
  }

  Widget _buildMetodoCard(_MetodoPagoInfo metodo, int index) {
    final isSelected = _metodoPagoSeleccionado == metodo.tipo;
    return GestureDetector(
      onTap: () => setState(() => _metodoPagoSeleccionado = metodo.tipo),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color:
              isSelected ? metodo.color.withOpacity(0.12) : AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? metodo.color.withOpacity(0.7) : Colors.white10,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: metodo.color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(metodo.icono, color: metodo.color, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    metodo.titulo,
                    style: TextStyle(
                      color: isSelected ? metodo.color : AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    metodo.subtitulo,
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? metodo.color : Colors.transparent,
                border: Border.all(
                  color: isSelected ? metodo.color : Colors.white24,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, color: Colors.white, size: 12)
                  : null,
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: index * 70));
  }

  Widget _buildSeguridad() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: const Row(
        children: [
          Icon(Icons.security_rounded, color: AppTheme.successColor, size: 16),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Transacción segura. Tu información es cifrada y protegida.',
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  // ─── PASO 2: Procesando ────────────────────────────────────────────────────

  Widget _buildProcesando({Key? key}) {
    final color = Color(widget.tramite.colorEntidad);
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Ícono animado
            AnimatedBuilder(
              animation: _pulseController,
              builder: (_, __) {
                final scale = 0.9 + 0.1 * _pulseController.value;
                return Transform.scale(
                  scale: scale,
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withOpacity(0.15),
                      border: Border.all(
                        color: color
                            .withOpacity(0.3 + 0.4 * _pulseController.value),
                        width: 2,
                      ),
                    ),
                    child: Icon(Icons.qr_code_scanner_rounded,
                        color: color, size: 48),
                  ),
                );
              },
            ),

            const SizedBox(height: 32),
            const Text(
              'Generando comprobante…',
              style: TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 10),
            const Text(
              'Por favor espera mientras procesamos\ntu solicitud de pago.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
            ),

            const SizedBox(height: 40),
            LinearProgressIndicator(
              backgroundColor: Colors.white10,
              valueColor: AlwaysStoppedAnimation(color),
            ),

            const SizedBox(height: 32),
            // Pasos del proceso
            ...[
              'Verificando datos del trámite',
              'Generando código único de pago',
              'Creando QR seguro',
            ].asMap().entries.map(
                  (e) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded,
                            color: AppTheme.successColor, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          e.value,
                          style: const TextStyle(
                              color: AppTheme.textSecondary, fontSize: 13),
                        ),
                      ],
                    )
                        .animate(delay: Duration(milliseconds: e.key * 600))
                        .fadeIn()
                        .slideX(begin: -0.05, end: 0),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  // ─── PASO 3: Comprobante QR ────────────────────────────────────────────────

  Widget _buildComprobante({Key? key}) {
    final color = Color(widget.tramite.colorEntidad);
    final metodo =
        _metodos.firstWhere((m) => m.tipo == _metodoPagoSeleccionado);

    return SingleChildScrollView(
      key: key,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Header de éxito
          _buildHeaderExito(color),
          const SizedBox(height: 24),

          // Código QR
          _buildQrCard(color),
          const SizedBox(height: 20),

          // Info de la transacción
          _buildInfoTransaccion(color, metodo),
          const SizedBox(height: 16),

          // Detalles del trámite
          _buildDetallesTramite(),
          const SizedBox(height: 16),

          // Instrucciones
          _buildInstrucciones(metodo),
          const SizedBox(height: 20),

          // Botones de acción
          _buildBotonesAccion(color),
          const SizedBox(height: 20),

          // Disclaimer legal
          _buildDisclaimer(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHeaderExito(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Colors.white24,
              shape: BoxShape.circle,
            ),
            child:
                const Icon(Icons.check_rounded, color: Colors.white, size: 32),
          ).animate().scale(delay: 200.ms, curve: Curves.elasticOut),
          const SizedBox(height: 12),
          const Text(
            'Comprobante Generado',
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            'SmartTrámites · La Paz, Bolivia',
            style:
                TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.05, end: 0);
  }

  Widget _buildQrCard(Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.35),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          QrImageView(
            data: _qrConfirmado,
            version: QrVersions.auto,
            size: 210,
            backgroundColor: Colors.white,
            eyeStyle: QrEyeStyle(
              eyeShape: QrEyeShape.square,
              color: color,
            ),
            dataModuleStyle: const QrDataModuleStyle(
              dataModuleShape: QrDataModuleShape.square,
              color: AppTheme.darkBg,
            ),
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: AppTheme.darkBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'TX: ${_codigoTransaccion ?? ''}',
              style: const TextStyle(
                  color: AppTheme.secondaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  fontFamily: 'monospace'),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Emitido: ${DateFormat('dd/MM/yyyy · HH:mm').format(_fechaEmision)}',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 11),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: 200.ms)
        .scale(begin: const Offset(0.92, 0.92), curve: Curves.easeOutBack);
  }

  Widget _buildInfoTransaccion(Color color, _MetodoPagoInfo metodo) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        children: [
          _filaInfo(
            'Estado',
            'Pendiente de pago',
            Icons.pending_actions_rounded,
            const Color(0xFFFFD600),
          ),
          _divider(),
          _filaInfo(
            'Método seleccionado',
            metodo.titulo,
            metodo.icono,
            metodo.color,
          ),
          _divider(),
          _filaInfo(
            'Monto total',
            widget.tramite.costo,
            Icons.payments_outlined,
            color,
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildDetallesTramite() {
    final color = Color(widget.tramite.colorEntidad);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Detalles del Trámite',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.5),
          ),
          const SizedBox(height: 14),
          _filaInfo('Trámite', widget.tramite.nombre,
              Icons.description_outlined, color),
          _divider(),
          _filaInfo('Entidad', widget.tramite.entidad,
              Icons.account_balance_outlined, color),
          _divider(),
          _filaInfo('Tiempo estimado', widget.tramite.duracionEstimada,
              Icons.timer_outlined, AppTheme.secondaryColor),
        ],
      ),
    ).animate().fadeIn(delay: 350.ms);
  }

  Widget _buildInstrucciones(_MetodoPagoInfo metodo) {
    final instrucciones = _getInstrucciones(metodo.tipo);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: metodo.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: metodo.color.withOpacity(0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.info_outline_rounded, color: metodo.color, size: 18),
              const SizedBox(width: 8),
              Text(
                'Instrucciones de pago',
                style: TextStyle(
                    color: metodo.color,
                    fontSize: 14,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...instrucciones.asMap().entries.map(
                (e) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: metodo.color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${e.key + 1}',
                            style: TextStyle(
                                color: metodo.color,
                                fontSize: 11,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          e.value,
                          style: TextStyle(
                              color: metodo.color.withOpacity(0.85),
                              fontSize: 13,
                              height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms);
  }

  List<String> _getInstrucciones(MetodoPago tipo) {
    switch (tipo) {
      case MetodoPago.qrBancario:
        return [
          'Abre tu app bancaria (Banco Unión, BNB u otro).',
          'Selecciona "Pagar con QR" o "Escanear QR".',
          'Escanea el código QR de esta pantalla.',
          'Confirma el monto de ${widget.tramite.costo} y acepta el pago.',
          'Guarda el comprobante que te genera tu banco.',
        ];
      case MetodoPago.tarjetaDebito:
        return [
          'Acércate a la caja de la entidad: ${widget.tramite.entidad}.',
          'Muestra este comprobante al cajero.',
          'Presenta tu tarjeta de débito Visa o Mastercard.',
          'Confirma el pago de ${widget.tramite.costo}.',
        ];
      case MetodoPago.tarjetaCredito:
        return [
          'Acércate a la caja de la entidad: ${widget.tramite.entidad}.',
          'Muestra este comprobante al cajero.',
          'Presenta tu tarjeta de crédito.',
          'Verifica el cargo de ${widget.tramite.costo} en tu estado de cuenta.',
        ];
      case MetodoPago.efectivo:
        return [
          'Acércate a la ventanilla de ${widget.tramite.entidad}.',
          'Muestra este comprobante con tu CI.',
          'Paga el monto de ${widget.tramite.costo} en efectivo.',
          'Solicita tu recibo oficial de pago.',
        ];
    }
  }

  Widget _buildBotonesAccion(Color color) {
    return Column(
      children: [
        // Botón compartir
        OutlinedButton.icon(
          onPressed: () {
            HapticFeedback.lightImpact();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Row(
                  children: [
                    Icon(Icons.share_rounded, color: Colors.white, size: 16),
                    SizedBox(width: 8),
                    Text('Comprobante listo para compartir'),
                  ],
                ),
                backgroundColor: AppTheme.cardMedium,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          icon: const Icon(Icons.share_rounded, size: 18),
          label: const Text('Compartir Comprobante',
              style: TextStyle(fontWeight: FontWeight.w600)),
          style: OutlinedButton.styleFrom(
            foregroundColor: color,
            side: BorderSide(color: color.withOpacity(0.5)),
            minimumSize: const Size(double.infinity, 50),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
        const SizedBox(height: 10),
        // Botón volver al inicio
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
          icon: const Icon(Icons.home_rounded, size: 18),
          label: const Text('Volver al Inicio',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            minimumSize: const Size(double.infinity, 54),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 450.ms);
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.warningColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.warningColor.withOpacity(0.25)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, color: AppTheme.warningColor, size: 16),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Este comprobante es una guía digital de gestión de trámites. '
              'El pago y la validación final corresponden a la institución '
              'emisora. SmartTrámites no procesa ni almacena pagos reales.',
              style: TextStyle(
                  color: AppTheme.warningColor, fontSize: 11, height: 1.5),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 500.ms);
  }

  Widget _buildError({Key? key}) {
    return Center(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                color: AppTheme.errorColor, size: 72),
            const SizedBox(height: 20),
            const Text('Ocurrió un error',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            const Text(
              'No pudimos generar el comprobante.\nIntenta nuevamente.',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => setState(() => _estado = EstadoPago.seleccion),
              child: const Text('Intentar de nuevo'),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Helpers de UI ─────────────────────────────────────────────────────────

  Widget _filaInfo(String label, String valor, IconData icono, Color color) {
    return Row(
      children: [
        Icon(icono, color: color, size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 11)),
              const SizedBox(height: 2),
              Text(valor,
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => const Divider(color: Colors.white10, height: 20);
}
