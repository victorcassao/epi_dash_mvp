import 'package:epi_dash_mvp/common/widgets/forms/company_dropdown.dart';
import 'package:epi_dash_mvp/common/widgets/forms/form_action_buttons.dart';
import 'package:epi_dash_mvp/common/widgets/forms/form_text_field.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_add_camera_controller.dart';
import 'package:epi_dash_mvp/routes/admin_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminAddCameraScreen extends GetView<AdminAddCameraController> {
  const AdminAddCameraScreen({super.key});

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
              child: _CameraForm(),
            ),
          ),
        ),
      ),
    );
  }
}

class _CameraForm extends GetView<AdminAddCameraController> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final locationCtrl = TextEditingController();
    final modelCtrl = TextEditingController();

    return Form(
      key: formKey,
      child: ListView(
        shrinkWrap: true,
        children: [
          // Título
          const _FormHeader(),
          const SizedBox(height: 32),

          // Dropdown de Empresas
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
          const SizedBox(height: 16),

          // Localização
          FormTextField(
            controller: locationCtrl,
            label: 'Localização *',
            hint: 'Ex: Entrada Principal, Saída Garagem',
            icon: Icons.location_on,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe a localização';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Modelo
          FormTextField(
            controller: modelCtrl,
            label: 'Modelo *',
            hint: 'Ex: Intelbras VHD 1220 B',
            icon: Icons.videocam,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Informe o modelo';
              }
              return null;
            },
          ),
          const SizedBox(height: 32),

          // Botões
          Obx(() => FormActionButtons(
            isLoading: controller.isLoading.value,
            isEnabled: controller.companies.isNotEmpty,
            onSubmit: () {
              if (formKey.currentState!.validate()) {
                controller.createCamera(
                  location: locationCtrl.text.trim(),
                  model: modelCtrl.text.trim(),
                );
              }
            },
            onCancel: () {
              Get.toNamed(AdminRoutes.adminListStreams);
            },
            submitLabel: 'Cadastrar Câmera',
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
          Icons.videocam,
          size: 48,
          color: Colors.blue,
        ),
        const SizedBox(height: 16),
        const Text(
          'Nova Câmera',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Configure uma nova câmera de monitoramento',
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