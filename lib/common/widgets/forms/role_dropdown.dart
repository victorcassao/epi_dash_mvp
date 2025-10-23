import 'package:epi_dash_mvp/modules/companies/models/employees.dart';
import 'package:flutter/material.dart';

class RoleDropdown extends StatelessWidget {
  final EmployeeRole? selectedRole;
  final void Function(EmployeeRole?)? onChanged;
  final String? Function(EmployeeRole?)? validator;

  const RoleDropdown({
    super.key,
    required this.selectedRole,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<EmployeeRole>(
      value: selectedRole,
      decoration: const InputDecoration(
        labelText: 'Cargo *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.badge),
        helperText: 'Gerente: acesso completo | Operador: apenas visualização',
      ),
      items: EmployeeRole.values.map((role) {
        return DropdownMenuItem(
          value: role,
          child: Row(
            children: [
              Icon(
                role == EmployeeRole.manager
                    ? Icons.admin_panel_settings
                    : Icons.visibility,
                size: 20,
                color: role == EmployeeRole.manager
                    ? Colors.blue
                    : Colors.grey,
              ),
              const SizedBox(width: 8),
              Text(role.displayName),
            ],
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}
