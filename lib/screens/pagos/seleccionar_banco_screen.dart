import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/tramite_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/banco_model.dart';
import '../../config/routes.dart';

class SeleccionarBancoScreen extends StatefulWidget {
  final String? prefillMonto;
  final String? prefillConcepto;

  const SeleccionarBancoScreen({
    super.key,
    this.prefillMonto,
    this.prefillConcepto,
  });

  @override
  State<SeleccionarBancoScreen> createState() => _SeleccionarBancoScreenState();
}

class _SeleccionarBancoScreenState extends State<SeleccionarBancoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _montoCtrl = TextEditingController();
  final _conceptoCtrl = TextEditingController();
  Banco? _selectedBanco;
  bool _isLoading = false;
  String? _searchQuery;

  @override
  void initState() {
    super.initState();
    _montoCtrl.text = widget.prefillMonto ?? '';
    _conceptoCtrl.text = widget.prefillConcepto ?? 'Pago de Trámite';
  }

  @override
  void dispose() {
    _montoCtrl.dispose();
    _conceptoCtrl.dispose();
    super.dispose();
  }

  Future<void> _generarPago() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBanco == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un banco para continuar')),
      );
      return;
    }

    final auth = context.read<AuthProvider>();
    if (auth.currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes iniciar sesión para pagar')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final success = await context.read<TramiteProvider>().prepareQRPayment(
          bancoCodigo: _selectedBanco!.codigo,
          monto: _montoCtrl.text.trim(),
          concepto: _conceptoCtrl.text.trim(),
          userId: auth.currentUser!.id,
        );

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushNamed(context, Routes.pagoQR);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error al generar código QR. Intenta nuevamente.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bancos = bancosBolivianos.where((b) {
      if (_searchQuery == null || _searchQuery!.isEmpty) {
        return true;
      }
      return b.nombre.toLowerCase().contains(_searchQuery!.toLowerCase()) ||
          b.codigo.toLowerCase().contains(_searchQuery!.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Seleccionar Banco')),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            // Formulario de Pago
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: const Offset(0, 2))
                ],
              ),
              child: Column(
                children: [
                  TextFormField(
                    controller: _montoCtrl,
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      labelText: 'Monto a Pagar (Bs)',
                      prefixIcon: const Icon(Icons.payments),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty)
                        return 'Ingresa el monto';
                      final amount = double.tryParse(v.replaceAll(',', '.'));
                      if (amount == null || amount <= 0)
                        return 'Monto inválido';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _conceptoCtrl,
                    decoration: InputDecoration(
                      labelText: 'Concepto de Pago',
                      prefixIcon: const Icon(Icons.description),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            // Buscador de Bancos
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar banco...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
            ),

            // Lista de Bancos
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: bancos.length,
                itemBuilder: (context, index) {
                  final banco = bancos[index];
                  final isSelected = _selectedBanco?.codigo == banco.codigo;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    elevation: isSelected ? 3 : 1,
                    color: isSelected ? Colors.blue.shade50 : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            isSelected ? Colors.blue : Colors.grey[200],
                        child: Icon(Icons.account_balance,
                            color:
                                isSelected ? Colors.white : Colors.grey[700]),
                      ),
                      title: Text(banco.nombre,
                          style: TextStyle(
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      subtitle: Text('Código: ${banco.codigo}'),
                      trailing: Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.blue : Colors.grey),
                      onTap: () => setState(() => _selectedBanco = banco),
                    ),
                  );
                },
              ),
            ),

            // Botón Continuar
            Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: _isLoading ? null : _generarPago,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(Icons.qr_code),
                label: const Text('GENERAR CÓDIGO QR'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
