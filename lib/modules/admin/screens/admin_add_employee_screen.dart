// lib/modules/admin/screens/admin_add_employee_screen.dart
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_employee_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddEmployeeScreen extends GetView<AdminAddEmployeeController> {
  const AdminAddEmployeeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final usernameController = TextEditingController();
    final passwordController = TextEditingController();
    final roleController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Novo Empregado'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Card(
            elevation: 4,
            margin: const EdgeInsets.all(24),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    const Text(
                      'Cadastrar Novo Empregado',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Dropdown de Empresas
                    Obx(() {
                      if (controller.isLoadingCompanies.value) {
                        return const Center(
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }

                      if (controller.companies.isEmpty) {
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

                      return DropdownButtonFormField(
                        value: controller.selectedCompany.value,
                        decoration: const InputDecoration(
                          labelText: 'Empresa *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: controller.companies
                            .map((company) => DropdownMenuItem(
                          value: company,
                          child: Text(company.name),
                        ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedCompany.value = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione uma empresa';
                          }
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 20),

                    // Nome
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome Completo *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Email
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
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

                    // Username
                    TextFormField(
                      controller: usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome de Usuário *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.account_circle),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome de usuário';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // Senha
                    TextFormField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Senha *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
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
                    const SizedBox(height: 20),

                    // Cargo/Função
                    TextFormField(
                      controller: roleController,
                      decoration: const InputDecoration(
                        labelText: 'Cargo/Função *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.work),
                        hintText: 'Ex: Gerente, Operador, etc.',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o cargo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),

                    // Botões
                    Obx(() {
                      final isLoading = controller.isLoading.value;
                      final hasCompanies = controller.companies.isNotEmpty;

                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : () => Get.back(),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: (isLoading || !hasCompanies)
                                  ? null
                                  : () {
                                if (formKey.currentState!.validate()) {
                                  controller.createEmployee(
                                    name: nameController.text.trim(),
                                    email: emailController.text.trim(),
                                    username: usernameController.text.trim(),
                                    password: passwordController.text.trim(),
                                    role: roleController.text.trim(),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                                  : const Text('Cadastrar'),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}