// lib/screens/detalle_tramite_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';
import 'qr_screen.dart';

class DetalleTramiteScreen extends StatefulWidget {
  final Tramite tramite;
  const DetalleTramiteScreen({super.key, required this.tramite});

  @override
  State<DetalleTramiteScreen> createState() => _DetalleTramiteScreenState();
}

class _DetalleTramiteScreenState extends State<DetalleTramiteScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Color get entidadColor => Color(widget.tramite.colorEntidad);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: entidadColor,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [entidadColor, entidadColor.withOpacity(0.6)],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          widget.tramite.entidad,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.tramite.nombre,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottom: TabBar(
              controller: _tabController,
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white60,
              tabs: const [
                Tab(text: 'Requisitos'),
                Tab(text: 'Pasos'),
                Tab(text: 'Costos'),
              ],
            ),
          ),
        ],
        body: Column(
          children: [
            _buildInfoRow(),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRequisitos(),
                  _buildPasos(),
                  _buildCostos(),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildInfoRow() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: AppTheme.cardDark,
      child: Row(
        children: [
          _infoChip(Icons.timer_outlined, widget.tramite.duracionEstimada,
              AppTheme.secondaryColor),
          const SizedBox(width: 12),
          _infoChip(Icons.category_outlined, widget.tramite.categoria,
              const Color(0xFF7C4DFF)),
        ],
      ),
    );
  }

  Widget _infoChip(IconData icon, String text, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 16),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                    color: color, fontSize: 12, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRequisitos() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Documentos Requeridos',
          style: TextStyle(
              color: entidadColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          '${widget.tramite.requisitos.length} documentos necesarios',
          style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13),
        ),
        const SizedBox(height: 16),
        ...widget.tramite.requisitos.asMap().entries.map((entry) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppTheme.cardDark,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: entidadColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      '${entry.key + 1}',
                      style: TextStyle(
                          color: entidadColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    entry.value,
                    style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        height: 1.4),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: entry.key * 60));
        }),
      ],
    );
  }

  Widget _buildPasos() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          'Procedimiento Paso a Paso',
          style: TextStyle(
              color: AppTheme.secondaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        ...widget.tramite.pasos.asMap().entries.map((entry) {
          final isLast = entry.key == widget.tramite.pasos.length - 1;
          return IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.secondaryColor,
                            entidadColor,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    if (!isLast)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: Colors.white12,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: isLast ? 0 : 20),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppTheme.cardDark,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white10),
                      ),
                      child: Text(
                        entry.value,
                        style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: Duration(milliseconds: entry.key * 80));
        }),
      ],
    );
  }

  Widget _buildCostos() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [entidadColor, entidadColor.withOpacity(0.6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.payments_outlined, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Costo del Trámite',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                widget.tramite.costo,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900),
              ),
            ],
          ),
        ).animate().fadeIn().scale(),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.timer_outlined,
                      color: AppTheme.secondaryColor, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Tiempo Estimado',
                    style: TextStyle(
                        color: AppTheme.secondaryColor,
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                widget.tramite.duracionEstimada,
                style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.warningColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppTheme.warningColor.withOpacity(0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline, color: AppTheme.warningColor, size: 20),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Los costos pueden variar. Verificar con la institución antes de realizar el pago.',
                  style: TextStyle(
                      color: AppTheme.warningColor,
                      fontSize: 13,
                      height: 1.4),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.cardDark,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Descripción',
                style: TextStyle(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Text(
                widget.tramite.descripcion,
                style: const TextStyle(
                    color: AppTheme.textPrimary, fontSize: 14, height: 1.5),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      color: AppTheme.cardDark,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => QrScreen(tramite: widget.tramite),
          ),
        ),
        icon: const Icon(Icons.qr_code, size: 20),
        label: const Text('Generar Comprobante QR',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        style: ElevatedButton.styleFrom(
          backgroundColor: entidadColor,
          minimumSize: const Size(double.infinity, 52),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }
}
