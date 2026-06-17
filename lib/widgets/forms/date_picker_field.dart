import 'package:flutter/material.dart';
import '../../config/constants.dart';

/// Campo compuesto para Cédula de Identidad boliviana
/// Devuelve un string formateado: "1234567-0 LP"
class CIInputField extends FormField<String> {
  CIInputField({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    String initialDepartamento = 'LP',
    bool showComplemento = true,
  }) : super(
          builder: (FormFieldState<String> state) {
            final _CIInputFieldState widgetState = state as _CIInputFieldState;
            return _CIInputFieldContent(
              state: widgetState,
              showComplemento: showComplemento,
              initialDepartamento: initialDepartamento,
              errorText: state.errorText,
            );
          },
        );

  @override
  FormFieldState<String> createState() => _CIInputFieldState();
}

class _CIInputFieldState extends FormFieldState<String> {
  late TextEditingController _ciCtrl;
  late TextEditingController _compCtrl;
  late String _selectedDepto;

  @override
  void initState() {
    super.initState();
    // Parsear valor inicial si existe
    final initial = widget.initialValue ?? '';
    final parts = initial.split(' ');
    final numPart = parts.isNotEmpty ? parts[0] : '';
    final deptoPart = parts.length > 1 ? parts[1] : 'LP';

    final numComponents = numPart.split('-');
    _ciCtrl = TextEditingController(text: numComponents[0]);
    _compCtrl = TextEditingController(
        text: numComponents.length > 1 ? numComponents[1] : '');
    _selectedDepto =
        AppConstants.departamentos.containsKey(deptoPart) ? deptoPart : 'LP';

    _ciCtrl.addListener(_updateValue);
    _compCtrl.addListener(_updateValue);
  }

  @override
  void dispose() {
    _ciCtrl.removeListener(_updateValue);
    _compCtrl.removeListener(_updateValue);
    _ciCtrl.dispose();
    _compCtrl.dispose();
    super.dispose();
  }

  void _updateValue() {
    final formatted = _ciCtrl.text.trim().isEmpty
        ? ''
        : '${_ciCtrl.text.trim()}-${_compCtrl.text.trim().isEmpty ? '0' : _compCtrl.text.trim()} $_selectedDepto';
    didChange(formatted);
  }

  void updateDepartamento(String depto) {
    setState(() => _selectedDepto = depto);
    _updateValue();
  }

  String get ciNumber => _ciCtrl.text.trim();
  String get complemento => _compCtrl.text.trim();
  String get departamento => _selectedDepto;
}

class _CIInputFieldContent extends StatelessWidget {
  final _CIInputFieldState state;
  final bool showComplemento;
  final String initialDepartamento;
  final String? errorText;

  const _CIInputFieldContent({
    required this.state,
    required this.showComplemento,
    required this.initialDepartamento,
    required this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(
          color: errorText != null
              ? Colors.red
              : theme.colorScheme.primary.withValues(alpha: 0.3)),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(
                controller: state._ciCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Número de CI',
                  prefixIcon: const Icon(Icons.credit_card, size: 20),
                  border: border,
                  errorText: null, // El error se muestra abajo
                ),
              ),
            ),
            if (showComplemento) ...[
              const SizedBox(width: 8),
              Expanded(
                flex: 1,
                child: TextFormField(
                  controller: state._compCtrl,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Comp.',
                    border: border,
                  ),
                  maxLength: 3,
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: state._selectedDepto,
          decoration: InputDecoration(
            labelText: 'Lugar de Expedición',
            prefixIcon: const Icon(Icons.location_on, size: 20),
            border: border,
            errorText: errorText,
          ),
          items: AppConstants.departamentos.entries
              .map<DropdownMenuItem<String>>((e) {
            return DropdownMenuItem<String>(
                value: e.key, child: Text('${e.value} ($e.key)'));
          }).toList(),
          onChanged: (val) {
            if (val != null) state.updateDepartamento(val);
          },
        ),
      ],
    );
  }
}
