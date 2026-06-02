// lib/screens/entidades_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../data/tramites_data.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';
import '../widgets/tramite_card.dart';
import 'detalle_tramite_screen.dart';

class EntidadesScreen extends StatelessWidget {
  const EntidadesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: const Text('Entidades'),
        backgroundColor: AppTheme.darkBg,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final entidad = entidades[index];
                  final tramitesEntidad =
                      tramitesData.where((t) => t.entidad == entidad).toList();
                  final color = colorPorEntidad(entidad);
                  final icono = iconoPorEntidad(entidad);
                  return _EntidadCard(
                    entidad: entidad,
                    icono: icono,
                    color: color,
                    tramites: tramitesEntidad,
                    index: index,
                  );
                },
                childCount: entidades.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C4DFF26), Color(0xFF0D47A126)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF7C4DFF40)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF7C4DFF20),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_rounded,
                color: Color(0xFF7C4DFF), size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${entidades.length} entidades registradas',
                  style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '${tramitesData.length} trámites disponibles en La Paz',
                  style: const TextStyle(
                      color: AppTheme.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn();
  }
}

class _EntidadCard extends StatefulWidget {
  final String entidad;
  final String icono;
  final Color color;
  final List<Tramite> tramites;
  final int index;

  const _EntidadCard({
    required this.entidad,
    required this.icono,
    required this.color,
    required this.tramites,
    required this.index,
  });

  @override
  State<_EntidadCard> createState() => _EntidadCardState();
}

class _EntidadCardState extends State<_EntidadCard> {
  bool _expandido = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppTheme.cardDark,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _expandido ? widget.color.withOpacity(0.4) : Colors.white10,
        ),
      ),
      child: Column(
        children: [
          // Header de la entidad
          InkWell(
            onTap: () => setState(() => _expandido = !_expandido),
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: widget.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: widget.color.withOpacity(0.25)),
                    ),
                    child: Center(
                      child: Text(widget.icono,
                          style: const TextStyle(fontSize: 24)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.entidad,
                          style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: widget.color.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${widget.tramites.length} trámite${widget.tramites.length != 1 ? 's' : ''}',
                                style: TextStyle(
                                    color: widget.color,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  AnimatedRotation(
                    turns: _expandido ? 0.5 : 0,
                    duration: const Duration(milliseconds: 250),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: widget.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.keyboard_arrow_down_rounded,
                          color: widget.color, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Lista de trámites expandible
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 250),
            crossFadeState: _expandido
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Column(
              children: [
                Container(height: 1, color: Colors.white10),
                const SizedBox(height: 8),
                ...widget.tramites.map((t) => TramiteCard(
                      tramite: t,
                      compact: true,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetalleTramiteScreen(tramite: t),
                        ),
                      ),
                    )),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: widget.index * 80))
        .slideY(begin: 0.05, end: 0);
  }
}
