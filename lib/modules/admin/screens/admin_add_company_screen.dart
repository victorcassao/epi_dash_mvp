import 'package:epi_dash_mvp/common/widgets/forms/form_action_buttons.dart';
import 'package:epi_dash_mvp/common/widgets/forms/form_text_field.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_company_controller.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminAddCompanyScreen extends GetView<AdminAddCompanyController> {
  const AdminAddCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: _CompanyForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompanyForm extends GetView<AdminAddCompanyController> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final cnpjController = TextEditingController();

    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          // Título
          const _FormHeader(),
          const SizedBox(height: 32),

          // Nome da Empresa
          FormTextField(
            controller: nameController,
            label: 'Nome da Empresa *',
            icon: Icons.business,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o nome da empresa';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // CNPJ
          FormTextField(
            controller: cnpjController,
            label: 'CNPJ *',
            hint: '00000000000000',
            icon: Icons.badge,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(14),
            ],
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o CNPJ';
              }
              if (value.length != 14) {
                return 'CNPJ deve ter exatamente 14 dígitos';
              }
              return null;
            },
          ),
          const SizedBox(height: 8),
          Text(
            'Apenas números (14 dígitos)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Botões
          Obx(() => FormActionButtons(
            isLoading: controller.isLoading.value,
            isEnabled: true,
            onSubmit: () {
              if (formKey.currentState!.validate()) {
                controller.createCompany(
                  name: nameController.text.trim(),
                  cnpj: cnpjController.text.trim(),
                );
              }
            },
            onCancel: () {
              Get.toNamed(AdminRoutes.adminListStreams);
            },
            submitLabel: 'Cadastrar Empresa',
            loadingLabel: 'Cadastrando...',
          )),
        ],
      ),
    );
  }
}

class _FormHeader extends StatelessWidget {
  const _FormHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.business,
          size: 48,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        const Text(
          'Cadastrar Nova Empresa',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione uma nova empresa ao sistema',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}