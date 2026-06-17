import 'package:flutter/material.dart';

/// Dropdown genérico con estilo unificado y soporte para tipos personalizados
class DropdownField<T> extends FormField<T> {
  DropdownField({
    super.key,
    super.initialValue,
    super.validator,
    super.onSaved,
    super.autovalidateMode = AutovalidateMode.disabled,
    required List<DropdownMenuItem<T>> items,
    String? labelText,
    String? hintText,
    IconData? prefixIcon,
    bool isExpanded = true,
    bool showClear = true,
  }) : super(
          builder: (FormFieldState<T> state) {
            return _DropdownFieldContent<T>(
              state: state as _DropdownFieldState<T>,
              items: items,
              labelText: labelText,
              hintText: hintText,
              prefixIcon: prefixIcon,
              isExpanded: isExpanded,
              showClear: showClear,
            );
          },
        );

  @override
  FormFieldState<T> createState() => _DropdownFieldState<T>();
}

class _DropdownFieldState<T> extends FormFieldState<T> {
  void clearSelection() {
    didChange(null);
  }
}

class _DropdownFieldContent<T> extends StatelessWidget {
  final _DropdownFieldState<T> state;
  final List<DropdownMenuItem<T>> items;
  final String? labelText;
  final String? hintText;
  final IconData? prefixIcon;
  final bool isExpanded;
  final bool showClear;

  const _DropdownFieldContent({
    required this.state,
    required this.items,
    required this.labelText,
    required this.hintText,
    required this.prefixIcon,
    required this.isExpanded,
    required this.showClear,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasValue = state.value != null;
    final borderColor = state.errorText != null
        ? Colors.red
        : theme.colorScheme.primary.withValues(alpha: 0.3);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.shade50,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: state.value,
              hint: Text(hintText ?? 'Seleccionar...',
                  style: TextStyle(color: Colors.grey.shade500)),
              isExpanded: isExpanded,
              icon: const Icon(Icons.arrow_drop_down),
              style: const TextStyle(fontSize: 15, color: Colors.black87),
              items: items,
              onChanged: (val) => state.didChange(val),
            ),
          ),
        ),
        if (labelText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(
              labelText!,
              style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500),
            ),
          ),
        if (state.errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4),
            child: Text(state.errorText!,
                style: TextStyle(color: Colors.red.shade700, fontSize: 12)),
          ),
        if (hasValue && showClear)
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: state.clearSelection,
              icon: const Icon(Icons.clear, size: 16),
              label: const Text('Limpiar'),
              style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
          ),
      ],
    );
  }
}
