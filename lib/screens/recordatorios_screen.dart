// lib/screens/recordatorios_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../models/tramite.dart';
import '../data/tramites_data.dart';
import '../theme/app_theme.dart';

class RecordatoriosScreen extends StatefulWidget {
  const RecordatoriosScreen({super.key});

  @override
  State<RecordatoriosScreen> createState() => _RecordatoriosScreenState();
}

class _RecordatoriosScreenState extends State<RecordatoriosScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Recordatorio> _recordatorios = [
    Recordatorio(
      id: '1',
      titulo: 'Renovar Cédula de Identidad',
      tramiteNombre: 'Obtención de Cédula de Identidad',
      fecha: DateTime.now().add(const Duration(days: 5)),
    ),
    Recordatorio(
      id: '2',
      titulo: 'Pagar patente municipal',
      tramiteNombre: 'Licencia de Funcionamiento',
      fecha: DateTime.now().add(const Duration(days: 12)),
    ),
    Recordatorio(
      id: '3',
      titulo: 'Declaración IVA mensual',
      tramiteNombre: 'Declaración Jurada de IVA',
      fecha: DateTime.now().add(const Duration(days: 20)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Recordatorio> get _pendientes =>
      _recordatorios.where((r) => !r.completado).toList();
  List<Recordatorio> get _completados =>
      _recordatorios.where((r) => r.completado).toList();

  int get _urgentes => _pendientes
      .where((r) => r.fecha.difference(DateTime.now()).inDays <= 3)
      .length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildResumenBanner(),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildListaRecordatorios(_pendientes, esPendiente: true),
                _buildListaRecordatorios(_completados, esPendiente: false),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _mostrarAgregarRecordatorio(context),
        backgroundColor: AppTheme.secondaryColor,
        icon: const Icon(Icons.add_alarm_rounded, color: Colors.white),
        label: const Text('Nuevo',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: const Text('Mis Recordatorios'),
      backgroundColor: AppTheme.darkBg,
    );
  }

  Widget _buildResumenBanner() {
    if (_recordatorios.isEmpty) return const SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.secondaryColor.withOpacity(0.15),
            const Color(0xFF7C4DFF).withOpacity(0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          _miniStat(
              '${_pendientes.length}', 'Pendientes', AppTheme.secondaryColor),
          _vertDivider(),
          _miniStat('${_urgentes}', 'Urgentes', AppTheme.errorColor),
          _vertDivider(),
          _miniStat(
              '${_completados.length}', 'Completados', AppTheme.successColor),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _miniStat(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  color: color, fontSize: 22, fontWeight: FontWeight.w900)),
          Text(label,
              style:
                  const TextStyle(color: AppTheme.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }

  Widget _vertDivider() =>
      Container(width: 1, height: 36, color: Colors.white10);

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.secondaryColor,
          borderRadius: BorderRadius.circular(10),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
        dividerColor: Colors.transparent,
        tabs: [
          Tab(text: 'Pendientes (${_pendientes.length})'),
          Tab(text: 'Completados (${_completados.length})'),
        ],
      ),
    );
  }

  Widget _buildListaRecordatorios(List<Recordatorio> lista,
      {required bool esPendiente}) {
    if (lista.isEmpty) {
      return _buildEmpty(esPendiente);
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 100),
      itemCount: lista.length,
      itemBuilder: (context, index) => _recordatorioCard(lista[index], index),
    );
  }

  Widget _recordatorioCard(Recordatorio recordatorio, int index) {
    final dias = recordatorio.fecha.difference(DateTime.now()).inDays;
    final urgente = dias <= 3 && !recordatorio.completado;
    final vencido = dias < 0 && !recordatorio.completado;

    Color statusColor;
    if (recordatorio.completado) {
      statusColor = AppTheme.successColor;
    } else if (vencido) {
      statusColor = AppTheme.errorColor;
    } else if (urgente) {
      statusColor = AppTheme.warningColor;
    } else {
      statusColor = AppTheme.secondaryColor;
    }

    String statusLabel;
    if (recordatorio.completado) {
      statusLabel = 'Completado';
    } else if (vencido) {
      statusLabel = 'Vencido';
    } else if (dias == 0) {
      statusLabel = 'Hoy';
    } else if (dias == 1) {
      statusLabel = 'Mañana';
    } else {
      statusLabel = 'En $dias días';
    }

    return Dismissible(
      key: Key(recordatorio.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.errorColor.withOpacity(0.3)),
        ),
        child: const Icon(Icons.delete_outline_rounded,
            color: AppTheme.errorColor),
      ),
      onDismissed: (_) {
        setState(() => _recordatorios.remove(recordatorio));
        HapticFeedback.mediumImpact();
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: recordatorio.completado
                ? Colors.white10
                : statusColor.withOpacity(0.3),
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => setState(
                () => recordatorio.completado = !recordatorio.completado),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Checkbox
                  GestureDetector(
                    onTap: () {
                      setState(() =>
                          recordatorio.completado = !recordatorio.completado);
                      HapticFeedback.lightImpact();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 26,
                      height: 26,
                      decoration: BoxDecoration(
                        color: recordatorio.completado
                            ? AppTheme.successColor
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: recordatorio.completado
                              ? AppTheme.successColor
                              : statusColor,
                          width: 2,
                        ),
                      ),
                      child: recordatorio.completado
                          ? const Icon(Icons.check_rounded,
                              color: Colors.white, size: 14)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recordatorio.titulo,
                          style: TextStyle(
                            color: recordatorio.completado
                                ? AppTheme.textSecondary
                                : AppTheme.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            decoration: recordatorio.completado
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.description_outlined,
                                color: AppTheme.textSecondary, size: 12),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                recordatorio.tramiteNombre,
                                style: const TextStyle(
                                    color: AppTheme.textSecondary,
                                    fontSize: 12),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(Icons.calendar_today_outlined,
                                color: statusColor, size: 13),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd MMMM yyyy', 'es')
                                  .format(recordatorio.fecha),
                              style:
                                  TextStyle(color: statusColor, fontSize: 12),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: statusColor.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    color: statusColor.withOpacity(0.3)),
                              ),
                              child: Text(
                                statusLabel,
                                style: TextStyle(
                                    color: statusColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: index * 70))
        .slideX(begin: 0.04, end: 0);
  }

  Widget _buildEmpty(bool esPendiente) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(esPendiente ? '🔔' : '✅', style: const TextStyle(fontSize: 60)),
          const SizedBox(height: 20),
          Text(
            esPendiente ? 'Sin recordatorios' : 'Ninguno completado aún',
            style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            esPendiente
                ? 'Toca "Nuevo" para agregar\nun recordatorio de trámite'
                : 'Los trámites completados\naparecerán aquí',
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: AppTheme.textSecondary, fontSize: 14, height: 1.5),
          ),
        ],
      ),
    );
  }

  void _mostrarAgregarRecordatorio(BuildContext context) {
    final controller = TextEditingController();
    String? tramiteSeleccionado;
    DateTime fechaSeleccionada = DateTime.now().add(const Duration(days: 7));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.cardDark,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 6,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Nuevo Recordatorio',
                style: TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 6),
              const Text(
                'Configura un aviso para tu trámite pendiente',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 22),
              TextField(
                controller: controller,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Ej: Renovar carnet, Pagar impuestos...',
                  prefixIcon:
                      Icon(Icons.title_rounded, color: AppTheme.textSecondary),
                  labelText: 'Título',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                value: tramiteSeleccionado,
                dropdownColor: AppTheme.cardMedium,
                style: const TextStyle(color: AppTheme.textPrimary),
                decoration: const InputDecoration(
                  hintText: 'Seleccionar trámite',
                  prefixIcon: Icon(Icons.description_outlined,
                      color: AppTheme.textSecondary),
                  labelText: 'Trámite relacionado',
                  labelStyle: TextStyle(color: AppTheme.textSecondary),
                ),
                items: tramitesData
                    .map((t) => DropdownMenuItem(
                          value: t.nombre,
                          child: Text(t.nombre,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                  color: AppTheme.textPrimary, fontSize: 13)),
                        ))
                    .toList(),
                onChanged: (v) => setModalState(() => tramiteSeleccionado = v),
              ),
              const SizedBox(height: 14),
              GestureDetector(
                onTap: () async {
                  final date = await showDatePicker(
                    context: ctx,
                    initialDate: fechaSeleccionada,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                    builder: (context, child) => Theme(
                      data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.dark(
                          primary: AppTheme.secondaryColor,
                          surface: AppTheme.cardMedium,
                        ),
                      ),
                      child: child!,
                    ),
                  );
                  if (date != null) {
                    setModalState(() => fechaSeleccionada = date);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: AppTheme.cardMedium,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.event_rounded,
                          color: AppTheme.secondaryColor, size: 20),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Fecha del recordatorio',
                              style: TextStyle(
                                  color: AppTheme.textSecondary, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            DateFormat('dd/MM/yyyy').format(fechaSeleccionada),
                            style: const TextStyle(
                                color: AppTheme.textPrimary,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.chevron_right_rounded,
                          color: AppTheme.textSecondary, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 22),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      _recordatorios.add(Recordatorio(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        titulo: controller.text,
                        tramiteNombre: tramiteSeleccionado ?? 'General',
                        fecha: fechaSeleccionada,
                      ));
                    });
                    HapticFeedback.mediumImpact();
                    Navigator.pop(ctx);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.secondaryColor,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_alarm_rounded,
                        color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text('Guardar Recordatorio',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
