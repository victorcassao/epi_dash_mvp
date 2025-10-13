import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_camera_controller.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_company_model.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AdminAddCameraScreen extends GetView<AdminAddCameraController> {
  const AdminAddCameraScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final locationCtrl = TextEditingController();
    final modelCtrl = TextEditingController();

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
                      'Nova Câmera',
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.companies.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Text(
                            'Nenhuma empresa cadastrada. Cadastre uma empresa primeiro.',
                            style: TextStyle(color: Colors.orange),
                          ),
                        );
                      }

                      return DropdownButtonFormField<AdminCompanyModel>(
                        value: controller.selectedCompany.value,
                        decoration: const InputDecoration(
                          labelText: 'Empresa *',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.business),
                        ),
                        items: controller.companies.map((company) {
                          return DropdownMenuItem(
                            value: company,
                            child: Text(company.name),
                          );
                        }).toList(),
                        onChanged: (value) {
                          controller.selectedCompany.value = value;
                        },
                        validator: (value) {
                          if (value == null) return 'Selecione uma empresa';
                          return null;
                        },
                      );
                    }),
                    const SizedBox(height: 16),

                    // Localização
                    TextFormField(
                      controller: locationCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Localização *',
                        hintText: 'Ex: Entrada Principal, Saída Garagem',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe a localização';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Modelo
                    TextFormField(
                      controller: modelCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Modelo *',
                        hintText: 'Ex: Intelbras VHD 1220 B',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.videocam),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Informe o modelo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    // Botões
                    Obx(() {
                      final loading = controller.isLoading.value;
                      return Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: loading
                                  ? null
                                  : () {
                                if (formKey.currentState!.validate()) {
                                  controller.createCamera(
                                    location: locationCtrl.text.trim(),
                                    model: modelCtrl.text.trim(),
                                  );
                                }
                              },
                              icon: loading
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Icon(Icons.save),
                              label: Text(loading ? 'Cadastrando...' : 'Cadastrar'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: loading ? null : () {
                                Get.toNamed(AdminRoutes.adminListStreams);
                              },
                              icon: const Icon(Icons.cancel),
                              label: const Text('Cancelar'),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
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