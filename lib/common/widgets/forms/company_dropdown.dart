import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:flutter/material.dart';

class CompanyDropdown extends StatelessWidget {
  final AdminCompanyModel? selectedCompany;
  final List<AdminCompanyModel> companies;
  final void Function(AdminCompanyModel?)? onChanged;
  final bool isLoading;
  final String? Function(AdminCompanyModel?)? validator;

  const CompanyDropdown({
    super.key,
    required this.selectedCompany,
    required this.companies,
    required this.onChanged,
    this.isLoading = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('Carregando empresas...'),
          ],
        ),
      );
    }

    if (companies.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.orange),
        ),
        child: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange.shade700),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Nenhuma empresa cadastrada. Cadastre uma empresa primeiro.',
                style: TextStyle(fontSize: 14),
              ),
            ),
          ],
        ),
      );
    }

    return DropdownButtonFormField<AdminCompanyModel>(
      value: selectedCompany,
      decoration: const InputDecoration(
        labelText: 'Empresa *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.business),
      ),
      items: companies.map((company) {
        return DropdownMenuItem(
          value: company,
          child: Text(company.name),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}