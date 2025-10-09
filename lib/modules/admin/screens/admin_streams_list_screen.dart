import 'package:epi_dash_mvp/common/widgets/data_visualization/generic_paginated_data_table.dart';
import 'package:epi_dash_mvp/modules/admin/controllers/admin_streams_list_controller.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminStreamsListScreen extends GetView<AdminStreamsListController> {
  const AdminStreamsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todas as Streams (Admin)"),
        actions: [
          // Botão de refresh
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.refresh(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Erro ao carregar streams",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.loadStreams(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Tentar novamente"),
                ),
              ],
            ),
          );
        }

        return GenericPaginatedTable<AdminStreamModel>(
          title: "Total: ${controller.filteredStreams.length}",
          columns: _buildColumns(),
          rows: controller.filteredStreams,
          rowBuilder: _rowBuilder,
          filters: _buildFilters(),
        );
      }),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(label: Text("Ações")),
      DataColumn(label: Text("Empresa ID")),
      DataColumn(label: Text("Empresa")),
      DataColumn(label: Text("CNPJ")),
      DataColumn(label: Text("Status Empresa")),
      DataColumn(label: Text("Camera ID")),
      DataColumn(label: Text("Localização")),
      DataColumn(label: Text("Câmera Ativa?")),
      DataColumn(label: Text("Stream ID")),
      DataColumn(label: Text("FPS")),
      DataColumn(label: Text("Access Key")),
      DataColumn(label: Text("Status Stream")),
      DataColumn(label: Text("Última Atualização")),
      DataColumn(label: Text("Deve Streamar?")),
    ];
  }

  DataRow _rowBuilder(AdminStreamModel s) {
    return DataRow(cells: [
      DataCell(
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.visibility_outlined),
              onPressed: () {
                Get.toNamed('/admin/streams/${s.streamId}');
              },
            ),
          ],
        ),
      ),
      DataCell(SelectableText(s.companyId.toString())),
      DataCell(SelectableText(s.companyName.toString())),
      DataCell(SelectableText(s.companyCnpj.toString())),
      DataCell(Icon(
        s.companyIsActive == true ? Icons.check : Icons.close,
        color: s.companyIsActive == true ? Colors.green : Colors.red,
      )),
      DataCell(SelectableText(s.cameraId.toString())),
      DataCell(SelectableText(s.cameraLocation)),
      DataCell(Icon(
        s.cameraIsActive == true ? Icons.check : Icons.close,
        color: s.cameraIsActive == true ? Colors.green : Colors.red,
      )),
      DataCell(Text(s.streamId.toString())),
      DataCell(Text(s.streamTargetFps.toString())),
      DataCell(
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 180),
          child: SelectableText(s.streamAccessKey, maxLines: 1),
        ),
      ),
      DataCell(
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 140),
          child: Text(s.streamCurrentStatus ?? "-"),
        ),
      ),
      DataCell(
        ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 150),
          child: Text(s.formattedLastStatus),
        ),
      ),
      DataCell(Text(s.streamShouldStream == true ? "Sim" : "Não")),
    ]);
  }

  Widget _buildFilters() {
    return Obx(() => Row(
      children: [
        // Filtro por localização
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Filtrar por localização',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) => controller.updateLocationFilter(value),
          ),
        ),
        const SizedBox(width: 16),

        // Filtro por status
        DropdownButton<String>(
          value: controller.selectedStatus.value,
          hint: const Text("Status da stream"),
          items: const [
            DropdownMenuItem(value: "REQUESTED", child: Text("REQUESTED")),
            DropdownMenuItem(value: "PROCESSING", child: Text("PROCESSING")),
          ],
          onChanged: (value) => controller.updateStatusFilter(value),
        ),
        const SizedBox(width: 16),

        // Botão limpar
        TextButton(
          onPressed: () => controller.clearFilters(),
          child: const Text("Limpar filtros"),
        ),
      ],
    ));
  }
}