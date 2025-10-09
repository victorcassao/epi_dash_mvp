import 'package:epi_dash_mvp/common/widgets/data_visualization/generic_paginated_data_table.dart';
import 'package:epi_dash_mvp/modules/streams/controllers/streams_list_screen_controller.dart';
import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StreamListScreen extends GetView<StreamsListScreenController> {
  const StreamListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Streams cadastradas"),
        actions: [
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
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Erro ao carregar streams",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

        return GenericPaginatedTable<StreamModel>(
          title: "Streams (${controller.filteredStreams.length})",
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
      DataColumn(label: Text("Localização")),
      DataColumn(label: Text("Modelo")),
      DataColumn(label: Text("Ativa?")),
      DataColumn(label: Text("Access Key")),
      DataColumn(label: Text("FPS")),
      DataColumn(label: Text("Status Atual")),
      DataColumn(label: Text("Última Atualização")),
      DataColumn(label: Text("Deve Streamar?")),
      DataColumn(label: Text("Ações")),
    ];
  }

  DataRow _rowBuilder(StreamModel item) {
    return DataRow(
      cells: [
        DataCell(SelectableText(item.location)),
        DataCell(SelectableText(item.model)),
        DataCell(
          Icon(
            item.isActive ? Icons.check : Icons.close,
            color: item.isActive ? Colors.green : Colors.red,
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 180),
            child: SelectableText(item.accessKey, maxLines: 1),
          ),
        ),
        DataCell(Text(item.targetFps.toString())),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 140),
            child: Text(item.currentStatus),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: Text(item.formattedLastStatus),
          ),
        ),
        DataCell(Text(item.shouldStream ? "Sim" : "Não")),
        DataCell(
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.visibility_outlined),
                onPressed: () {
                  Get.toNamed('/streams/${item.streamId}');
                },
              ),
            ],
          ),
        ),
      ],
    );
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