import 'package:flutter/material.dart';

class FormActionButtons extends StatelessWidget {
  final bool isLoading;
  final bool isEnabled;
  final VoidCallback onSubmit;
  final VoidCallback onCancel;
  final String submitLabel;
  final String cancelLabel;
  final String? loadingLabel;

  const FormActionButtons({
    super.key,
    required this.isLoading,
    required this.isEnabled,
    required this.onSubmit,
    required this.onCancel,
    this.submitLabel = 'Cadastrar',
    this.cancelLabel = 'Cancelar',
    this.loadingLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: isLoading ? null : onCancel,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(cancelLabel),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: (isLoading || !isEnabled) ? null : onSubmit,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
            ),
            child: isLoading
                ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                ),
                if (loadingLabel != null) ...[
                  const SizedBox(width: 8),
                  Text(loadingLabel!),
                ],
              ],
            )
                : Text(submitLabel),
          ),
        ),
      ],
    );
  }
}