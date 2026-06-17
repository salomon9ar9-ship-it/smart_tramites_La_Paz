import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/user_provider.dart';
import '../../config/app_config.dart';
import '../../config/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: RefreshIndicator(
        onRefresh: () async {
          final auth = context.read<AuthProvider>();
          if (auth.currentUser != null) {
            await Future.wait([
              context
                  .read<TramiteProvider>()
                  .loadTramites(auth.currentUser!.id),
              context
                  .read<TramiteProvider>()
                  .loadRecordatorios(auth.currentUser!.id),
            ]);
          }
        },
        child: CustomScrollView(
          slivers: [
            // ── 1. HEADER SALUDO ──────────────────────────────────
            SliverToBoxAdapter(
              child: Container(
                color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.fromLTRB(20, 50, 20, 36),
                child: Consumer2<AuthProvider, UserProvider>(
                  builder: (context, auth, userProv, _) {
                    final user = auth.currentUser;
                    final nombre =
                        userProv.profile?.nombres ?? user?.nombres ?? 'Usuario';
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Bienvenido,',
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 16)),
                            Text(nombre,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        GestureDetector(
                          onTap: () =>
                              Navigator.pushNamed(context, Routes.perfil),
                          child: const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 25,
                            child: Icon(Icons.person,
                                size: 30, color: Colors.white),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // ── 2. TARJETAS ESTADÍSTICAS ──────────────────────────
            SliverToBoxAdapter(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Consumer<TramiteProvider>(
                    builder: (context, tramiteProv, _) {
                      final pendientes = tramiteProv.tramites.length;
                      final completados = tramiteProv.comprobantes.length;
                      final recordatorios = tramiteProv.recordatorios
                          .where((r) => !r.completado)
                          .length;
                      return Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _StatItem('Trámites', '$pendientes',
                                  Colors.orange, Icons.pending_actions),
                              _StatItem('Pagos', '$completados', Colors.green,
                                  Icons.check_circle),
                              _StatItem('Alertas', '$recordatorios', Colors.red,
                                  Icons.notifications_active),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),

            // ── 3. ACCESOS RÁPIDOS ────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Accesos Rápidos',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: [
                        _QuickTile(
                            'Licencia',
                            Icons.directions_car,
                            Colors.blue,
                            () => Navigator.pushNamed(
                                context, Routes.categoriasLicencia)),
                        _QuickTile(
                            'Bancos',
                            Icons.account_balance,
                            Colors.purple,
                            () => Navigator.pushNamed(context, Routes.bancos)),
                        _QuickTile('SEGIP', Icons.badge, Colors.deepPurple,
                            () => Navigator.pushNamed(context, Routes.segip)),
                        _QuickTile(
                            'Impuestos',
                            Icons.receipt_long,
                            Colors.green,
                            () =>
                                Navigator.pushNamed(context, Routes.impuestos)),
                        _QuickTile(
                            'Pago QR',
                            Icons.qr_code,
                            Colors.teal,
                            () => Navigator.pushNamed(
                                context, Routes.seleccionarBanco)),
                        _QuickTile(
                            'Historial',
                            Icons.history,
                            Colors.indigo,
                            () => Navigator.pushNamed(
                                context, Routes.historialPagos)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // ── 4. RECORDATORIOS RECIENTES ────────────────────────
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
              sliver: Consumer<TramiteProvider>(
                builder: (context, tramiteProv, _) {
                  final recordatorios = tramiteProv.recordatorios
                      .where((r) => !r.completado)
                      .take(3)
                      .toList();

                  if (recordatorios.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Column(
                          children: [
                            Text('Recordatorios Pendientes',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                            SizedBox(height: 12),
                            Text('No tienes alertas pendientes ✅',
                                style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index == 0) {
                          return const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: Text('Recordatorios Pendientes',
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold)),
                          );
                        }
                        final item = recordatorios[index - 1];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: Icon(Icons.alarm,
                                color: item.completado
                                    ? Colors.green
                                    : Colors.orange),
                            title: Text(item.titulo),
                            subtitle: Text(
                                'Vence: ${AppConfig.formatDate(item.fecha)}'),
                          ),
                        );
                      },
                      childCount: recordatorios.length + 1,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _StatItem(String label, String value, Color color, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 4),
        Text(value,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}

class _QuickTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickTile(this.title, this.icon, this.color, this.onTap);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30, color: color),
            const SizedBox(height: 6),
            Text(title,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800]),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
