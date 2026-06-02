// lib/screens/busqueda_screen.dart

import 'package:flutter/material.dart';
import '../data/tramites_data.dart';
import '../models/tramite.dart';
import '../theme/app_theme.dart';
import '../widgets/tramite_card.dart';
import 'detalle_tramite_screen.dart';

class BusquedaScreen extends StatefulWidget {
  const BusquedaScreen({super.key});

  @override
  State<BusquedaScreen> createState() => _BusquedaScreenState();
}

class _BusquedaScreenState extends State<BusquedaScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String? _entidadFiltro;
  String? _categoriaFiltro;

  List<Tramite> get _resultados {
    return tramitesData.where((t) {
      final matchQuery = _query.isEmpty ||
          t.nombre.toLowerCase().contains(_query.toLowerCase()) ||
          t.entidad.toLowerCase().contains(_query.toLowerCase()) ||
          t.categoria.toLowerCase().contains(_query.toLowerCase()) ||
          t.descripcion.toLowerCase().contains(_query.toLowerCase());
      final matchEntidad =
          _entidadFiltro == null || t.entidad == _entidadFiltro;
      final matchCategoria =
          _categoriaFiltro == null || t.categoria == _categoriaFiltro;
      return matchQuery && matchEntidad && matchCategoria;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.darkBg,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: const InputDecoration(
            hintText: 'Buscar trámite, entidad...',
            border: InputBorder.none,
            hintStyle: TextStyle(color: AppTheme.textSecondary),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        actions: [
          if (_query.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                setState(() => _query = '');
              },
            ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltros(),
          const Divider(color: Colors.white12, height: 1),
          Expanded(
            child: _resultados.isEmpty
                ? _buildEmpty()
                : ListView.builder(
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: _resultados.length,
                    itemBuilder: (context, index) {
                      final tramite = _resultados[index];
                      return TramiteCard(
                        tramite: tramite,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetalleTramiteScreen(tramite: tramite),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFiltros() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _filtroDropdown(
            'Entidad',
            entidades,
            _entidadFiltro,
            (v) => setState(() => _entidadFiltro = v),
          ),
          const SizedBox(width: 10),
          _filtroDropdown(
            'Categoría',
            categorias,
            _categoriaFiltro,
            (v) => setState(() => _categoriaFiltro = v),
          ),
          if (_entidadFiltro != null || _categoriaFiltro != null) ...[
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => setState(() {
                _entidadFiltro = null;
                _categoriaFiltro = null;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.errorColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppTheme.errorColor.withOpacity(0.4)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.close, color: AppTheme.errorColor, size: 14),
                    SizedBox(width: 4),
                    Text('Limpiar',
                        style: TextStyle(
                            color: AppTheme.errorColor, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _filtroDropdown(String label, List<String> opciones,
      String? selected, ValueChanged<String?> onChanged) {
    return PopupMenuButton<String>(
      color: AppTheme.cardMedium,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (v) => onChanged(v == 'Todos' ? null : v),
      itemBuilder: (_) => [
        PopupMenuItem(value: 'Todos', child: Text('Todos', style: const TextStyle(color: AppTheme.textPrimary))),
        ...opciones.map((o) => PopupMenuItem(
            value: o,
            child: Text(o, style: const TextStyle(color: AppTheme.textPrimary)))),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected != null
              ? AppTheme.secondaryColor.withOpacity(0.15)
              : AppTheme.cardMedium,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected != null
                  ? AppTheme.secondaryColor
                  : Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected ?? label,
              style: TextStyle(
                color: selected != null
                    ? AppTheme.secondaryColor
                    : AppTheme.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Icon(Icons.keyboard_arrow_down,
                color: selected != null
                    ? AppTheme.secondaryColor
                    : AppTheme.textSecondary,
                size: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('🔍', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          const Text(
            'Sin resultados',
            style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            _query.isEmpty
                ? 'Escribe para buscar un trámite'
                : 'No hay trámites para "$_query"',
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
