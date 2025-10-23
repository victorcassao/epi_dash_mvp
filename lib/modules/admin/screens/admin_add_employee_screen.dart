import 'package:epi_dash_mvp/common/widgets/forms/company_dropdown.dart';
import 'package:epi_dash_mvp/common/widgets/forms/form_action_buttons.dart';
import 'package:epi_dash_mvp/common/widgets/forms/form_text_field.dart';
import 'package:epi_dash_mvp/common/widgets/forms/role_dropdown.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_employee_controller.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddEmployeeScreen extends GetView<AdminAddEmployeeController> {
  const AdminAddEmployeeScreen({super.key});

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
              child: _EmployeeForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _EmployeeForm extends GetView<AdminAddEmployeeController> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();

    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          // Título
          const _FormHeader(),
          const SizedBox(height: 32),

          // Dropdown de Empresa
          Obx(() => CompanyDropdown(
            selectedCompany: controller.selectedCompany.value,
            companies: controller.companies,
            isLoading: controller.isLoadingCompanies.value,
            onChanged: (value) {
              controller.selectedCompany.value = value;
            },
            validator: (value) {
              if (value == null) return 'Selecione uma empresa';
              return null;
            },
          )),
          const SizedBox(height: 20),

          // Dropdown de Role
          Obx(() => RoleDropdown(
            selectedRole: controller.selectedRole.value,
            onChanged: (value) {
              controller.selectedRole.value = value;
            },
            validator: (value) {
              if (value == null) return 'Selecione um cargo';
              return null;
            },
          )),
          const SizedBox(height: 20),

          // Campos de texto
          FormTextField(
            controller: nameController,
            label: 'Nome Completo *',
            icon: Icons.person,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o nome';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          FormTextField(
            controller: emailController,
            label: 'Email *',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o email';
              }
              if (!value.contains('@')) {
                return 'Email inválido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          FormTextField(
            controller: usernameController,
            label: 'Nome de Usuário *',
            icon: Icons.account_circle,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o nome de usuário';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          FormTextField(
            controller: passwordController,
            label: 'Senha *',
            icon: Icons.lock,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a senha';
              }
              if (value.length < 6) {
                return 'Senha deve ter no mínimo 6 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Botões de ação
          Obx(() => FormActionButtons(
            isLoading: controller.isLoading.value,
            isEnabled: controller.companies.isNotEmpty,
            onSubmit: () {
              if (formKey.currentState!.validate()) {
                controller.createEmployee(
                  name: nameController.text.trim(),
                  email: emailController.text.trim(),
                  username: usernameController.text.trim(),
                  password: passwordController.text.trim(),
                  role: controller.selectedRole.value!.value,
                );
              }
            },
            onCancel: () {
              Get.toNamed(AdminRoutes.adminListStreams);
            },
            submitLabel: 'Cadastrar Funcionário',
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
          Icons.person_add,
          size: 48,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        const Text(
          'Cadastrar Novo Funcionário',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha os dados abaixo para criar uma nova conta',
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