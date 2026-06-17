import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/tramites.dart';
import '../../config/routes.dart';

class ListaTramitesScreen extends StatefulWidget {
  const ListaTramitesScreen({super.key});

  @override
  State<ListaTramitesScreen> createState() => _ListaTramitesScreenState();
}

class _ListaTramitesScreenState extends State<ListaTramitesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trámites'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'Catálogo'), Tab(text: 'Mis Trámites')],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar trámite o entidad...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [_buildCatalogoTab(), _buildMisTramitesTab()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCatalogoTab() {
    return Consumer<TramiteProvider>(
      builder: (context, provider, _) {
        final filtered = provider.catalogoTramites
            .where((t) =>
                t.nombre.toLowerCase().contains(_searchQuery) ||
                t.entidad.toLowerCase().contains(_searchQuery))
            .toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('No se encontraron trámites'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final tramite = filtered[index];
            return _TramiteCard(
              tramite: tramite,
              isStarted: false,
              onTap: () => Navigator.pushNamed(context, Routes.detalleTramite,
                  arguments: {'tramite': tramite}),
            );
          },
        );
      },
    );
  }

  Widget _buildMisTramitesTab() {
    return Consumer2<AuthProvider, TramiteProvider>(
      builder: (context, auth, tramiteProv, _) {
        if (auth.currentUser == null) {
          return const Center(child: Text('Inicia sesión para ver tus trámites'));
        }
        final filtered = tramiteProv.tramites
            .where((t) =>
                t.nombre.toLowerCase().contains(_searchQuery) ||
                t.entidad.toLowerCase().contains(_searchQuery))
            .toList();

        if (filtered.isEmpty) {
          return const Center(child: Text('Aún no has iniciado ningún trámite'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: filtered.length,
          itemBuilder: (context, index) {
            final tramite = filtered[index];
            return _TramiteCard(
              tramite: tramite,
              isStarted: true,
              onTap: () => Navigator.pushNamed(context, Routes.detalleTramite,
                  arguments: {'tramite': tramite}),
            );
          },
        );
      },
    );
  }
}

class _TramiteCard extends StatelessWidget {
  final Tramite tramite;
  final bool isStarted;
  final VoidCallback onTap;

  const _TramiteCard({required this.tramite, required this.isStarted, required this.onTap});

  IconData _getIconData() {
    switch (tramite.iconoEntidad) {
      case 'directions_car': return Icons.directions_car;
      case 'verified_user': return Icons.verified_user;
      case 'account_balance': return Icons.account_balance;
      case 'receipt_long': return Icons.receipt_long;
      case 'credit_card': return Icons.credit_card;
      default:
        final code = int.tryParse(tramite.iconoEntidad);
        if (code != null) return IconData(code, fontFamily: 'MaterialIcons');
        return Icons.folder;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(tramite.colorEntidad).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_getIconData(), color: Color(tramite.colorEntidad), size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tramite.nombre,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(tramite.entidad,
                        style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(tramite.costo,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
