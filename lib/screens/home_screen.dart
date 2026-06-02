// lib/screens/home_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/tramites_data.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';
import '../widgets/tramite_card.dart';
import '../widgets/entidad_chip.dart';
import 'detalle_tramite_screen.dart';
import 'busqueda_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _entidadSeleccionada = 'Todas';

  List<Tramite> get _tramitesFiltrados {
    if (_entidadSeleccionada == 'Todas') return tramitesData;
    return tramitesData
        .where((t) => t.entidad == _entidadSeleccionada)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(child: _buildBannerInfo()),
          SliverToBoxAdapter(child: _buildStats()),
          SliverToBoxAdapter(child: _buildEntidadesFilter()),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 20,
                    decoration: BoxDecoration(
                      color: AppTheme.secondaryColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _entidadSeleccionada == 'Todas'
                        ? 'Todos los Trámites'
                        : 'Trámites: $_entidadSeleccionada',
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${_tramitesFiltrados.length} resultado${_tramitesFiltrados.length != 1 ? 's' : ''}',
                    style: const TextStyle(
                        color: AppTheme.textSecondary, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final tramite = _tramitesFiltrados[index];
                return TramiteCard(
                  tramite: tramite,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleTramiteScreen(tramite: tramite),
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: Duration(milliseconds: index * 50))
                    .slideY(begin: 0.08, end: 0);
              },
              childCount: _tramitesFiltrados.length,
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: AppTheme.darkBg,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0D3B8C), Color(0xFF0A0E1A)],
            ),
          ),
          child: Stack(
            children: [
              // Círculos decorativos de fondo
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.secondaryColor.withOpacity(0.06),
                  ),
                ),
              ),
              Positioned(
                top: 20,
                right: 80,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.secondaryColor.withOpacity(0.04),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 60, 20, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.secondaryColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                                color:
                                    AppTheme.secondaryColor.withOpacity(0.3)),
                          ),
                          child:
                              const Text('📋', style: TextStyle(fontSize: 28)),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'SmartTrámites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                              ),
                              Text(
                                'La Paz · Bolivia',
                                style: TextStyle(
                                  color: AppTheme.secondaryColor,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Badge "Gratuito"
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                                color: AppTheme.successColor.withOpacity(0.4)),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.verified,
                                  color: AppTheme.successColor, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'Gratuito',
                                style: TextStyle(
                                    color: AppTheme.successColor,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Barra de búsqueda
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const BusquedaScreen()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.search, color: Colors.white60, size: 20),
                            SizedBox(width: 10),
                            Text(
                              'Buscar trámite, entidad o categoría...',
                              style: TextStyle(
                                  color: Colors.white60, fontSize: 14),
                            ),
                            Spacer(),
                            Icon(Icons.tune_rounded,
                                color: Colors.white38, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerInfo() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.secondaryColor.withOpacity(0.2)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded,
              color: AppTheme.secondaryColor, size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Guía digital de trámites municipales. Consulta requisitos, costos y pasos sin hacer filas.',
              style: TextStyle(
                  color: AppTheme.textSecondary, fontSize: 12, height: 1.4),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }

  Widget _buildStats() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Row(
        children: [
          _statCard('${tramitesData.length}', 'Trámites',
              Icons.description_outlined, AppTheme.secondaryColor),
          const SizedBox(width: 10),
          _statCard('${entidades.length}', 'Entidades',
              Icons.account_balance_outlined, const Color(0xFF7C4DFF)),
          const SizedBox(width: 10),
          _statCard('100%', 'Digital', Icons.phone_android_rounded,
              AppTheme.successColor),
        ],
      ).animate().fadeIn(delay: 100.ms),
    );
  }

  Widget _statCard(String value, String label, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
        decoration: BoxDecoration(
          color: AppTheme.cardDark,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.25)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.w800)),
            Text(label,
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildEntidadesFilter() {
    final todas = ['Todas', ...entidades];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 18, 16, 10),
          child: Text(
            'Filtrar por entidad',
            style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4),
          ),
        ),
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: todas.length,
            itemBuilder: (context, index) {
              final entidad = todas[index];
              final isSelected = _entidadSeleccionada == entidad;
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: EntidadChip(
                  label: entidad,
                  isSelected: isSelected,
                  onTap: () => setState(() => _entidadSeleccionada = entidad),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
