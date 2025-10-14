// lib/modules/admin/screens/admin_add_company_screen.dart
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_company_controller.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ Importado para FilteringTextInputFormatter
import 'package:get/get.dart';

class AdminAddCompanyScreen extends GetView<AdminAddCompanyController> {
  const AdminAddCompanyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final cnpjController = TextEditingController();

    return Scaffold(
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
                      'Cadastrar Nova Empresa',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // Nome da Empresa
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nome da Empresa *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o nome da empresa';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    // CNPJ
                    TextFormField(
                      controller: cnpjController,
                      decoration: const InputDecoration(
                        labelText: 'CNPJ *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge),
                        hintText: '00000000000000',
                        helperText: 'Apenas números (14 dígitos)',
                      ),
                      keyboardType: TextInputType.number,
                      // ✅ Limita a entrada para 14 dígitos numéricos
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly, // Apenas números
                        LengthLimitingTextInputFormatter(14), // Máximo 14 caracteres
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
                    const SizedBox(height: 32),

                    // Botões
                    Obx(() {
                      final isLoading = controller.isLoading.value;
                      return Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: isLoading ? null : () {
                                Get.toNamed(AdminRoutes.adminListStreams);
                              },
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                if (formKey.currentState!.validate()) {
                                  controller.createCompany(
                                    name: nameController.text.trim(),
                                    cnpj: cnpjController.text.trim(),
                                  );
                                }
                                Get.toNamed(AdminRoutes.adminListStreams);
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