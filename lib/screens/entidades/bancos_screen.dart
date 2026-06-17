import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/banco_model.dart';
import '../../config/routes.dart';

class BancosScreen extends StatefulWidget {
  const BancosScreen({super.key});

  @override
  State<BancosScreen> createState() => _BancosScreenState();
}

class _BancosScreenState extends State<BancosScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectBankForPayment(Banco banco) {
    final auth = context.read<AuthProvider>();
    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Inicia sesión para realizar pagos')),
      );
      return;
    }

    // Navega a selección de banco para pago QR
    Navigator.pushNamed(
      context,
      Routes.seleccionarBanco,
      arguments: {'banco': banco, 'concepto': 'Pago de Trámite'},
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = bancosBolivianos
        .where((b) =>
            b.nombre.toLowerCase().contains(_query.toLowerCase()) ||
            b.codigo.toLowerCase().contains(_query.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bancos Bolivianos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: 'Escanear QR de pago',
            onPressed: () => Navigator.pushNamed(context, Routes.pagoQR,
                arguments: {'monto': '0.00', 'concepto': 'Pago manual'}),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar banco o código...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        })
                    : null,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (val) => setState(() => _query = val.trim()),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No se encontraron bancos'))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final banco = filtered[index];
                      return _BankCard(
                        banco: banco,
                        onTap: () => _selectBankForPayment(banco),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _BankCard extends StatelessWidget {
  final Banco banco;
  final VoidCallback onTap;

  const _BankCard({required this.banco, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade50,
          child: Icon(Icons.account_balance, color: Colors.blue.shade700),
        ),
        title: Text(banco.nombre,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Código: ${banco.codigo}'),
        trailing:
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
