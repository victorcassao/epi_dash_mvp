import 'package:epi_dash_mvp/common/widgets/data_visualization/generic_paginated_data_table.dart';
import 'package:epi_dash_mvp/modules/alerts/controllers/camera_alerts_controller.dart';
import 'package:epi_dash_mvp/modules/alerts/models/alert_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CameraAlertsScreen extends GetView<CameraAlertsController> {
  const CameraAlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // ⭐ AppBar JÁ TEM O BOTÃO DE VOLTAR AUTOMÁTICO
        // Apenas customizamos o título e ação de refresh
        title: Obx(() => Text(
          controller.cameraLocation.value.isEmpty
              ? "Alertas da Câmera"
              : "Alertas - ${controller.cameraLocation.value}",
        )),
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
                  "Erro ao carregar alertas",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(controller.errorMessage.value),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => controller.loadAlerts(),
                  icon: const Icon(Icons.refresh),
                  label: const Text("Tentar novamente"),
                ),
              ],
            ),
          );
        }

        if (controller.alerts.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 64,
                  color: Colors.grey,
                ),
                SizedBox(height: 16),
                Text(
                  "Nenhum alerta registrado para esta câmera",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // ⭐ REMOVIDO O PADDING COM BOTÃO DE VOLTAR EXTRA
        // Agora apenas a tabela
        return GenericPaginatedTable<AlertModel>(
          title: "Total: ${controller.filteredAlerts.length} alertas",
          columns: _buildColumns(),
          rows: controller.filteredAlerts,
          rowBuilder: _rowBuilder,
          filters: _buildFilters(),
        );
      }),
    );
  }

  List<DataColumn> _buildColumns() {
    return const [
      DataColumn(label: Text("ID")),
      DataColumn(label: Text("Tipo de Alerta")),
      DataColumn(label: Text("Status")),
      DataColumn(label: Text("Status Notificação")),
      DataColumn(label: Text("Detectado em")),
    ];
  }

  DataRow _rowBuilder(AlertModel alert) {
    final statusInfo = alert.statusInfo;
    final notificationInfo = alert.notificationStatusInfo;

    return DataRow(
      cells: [
        DataCell(SelectableText(alert.id.toString())),
        DataCell(
          Row(
            children: [
              Icon(
                alert.alertTypeIcon,
                size: 20,
                color: alert.alertTypeColor,
              ),
              const SizedBox(width: 8),
              Text(alert.formattedAlertType),
            ],
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: statusInfo.color),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(statusInfo.icon, size: 16, color: statusInfo.color),
                const SizedBox(width: 4),
                Text(
                  statusInfo.label,
                  style: TextStyle(
                    color: statusInfo.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              notificationInfo.label,
              style: TextStyle(
                color: notificationInfo.color,
                fontSize: 12,
              ),
            ),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: Text(alert.formattedDetectedAt),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    return Obx(() => Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        // ⭐ FILTRO COM APENAS 2 OPÇÕES
        SizedBox(
          width: 250,
          child: DropdownButtonFormField<String>(
            value: controller.selectedAlertType.value,
            decoration: const InputDecoration(
              labelText: 'Tipo de Alerta',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(
                  value: "SEM_USO_EPI",
                  child: Text("Sem Uso de EPI")
              ),
              DropdownMenuItem(
                  value: "ULTRAPASSOU_AREA_RESTRITA",
                  child: Text("Ultrapassou Área Restrita")
              ),
            ],
            onChanged: (value) => controller.updateAlertTypeFilter(value),
          ),
        ),

        // Filtro por status
        SizedBox(
          width: 200,
          child: DropdownButtonFormField<String>(
            value: controller.selectedStatus.value,
            decoration: const InputDecoration(
              labelText: 'Status',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            items: const [
              DropdownMenuItem(value: "PENDENTE", child: Text("Pendente")),
              DropdownMenuItem(value: "RESOLVIDO", child: Text("Resolvido")),
              DropdownMenuItem(value: "EM_ANALISE", child: Text("Em Análise")),
              DropdownMenuItem(value: "IGNORADO", child: Text("Ignorado")),
            ],
            onChanged: (value) => controller.updateStatusFilter(value),
          ),
        ),

        // Botão limpar
        ElevatedButton.icon(
          onPressed: () => controller.clearFilters(),
          icon: const Icon(Icons.clear),
          label: const Text("Limpar filtros"),
        ),
      ],
    ));
  }
}
