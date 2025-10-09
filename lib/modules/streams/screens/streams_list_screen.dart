import 'package:epi_dash_mvp/common/config/app_config.dart';
import 'package:epi_dash_mvp/common/widgets/data_visualization/generic_paginated_data_table.dart';
import 'package:epi_dash_mvp/modules/streams/controllers/streams_list_screen_controller.dart';
import 'package:epi_dash_mvp/modules/streams/models/stream_model.dart';
import 'package:epi_dash_mvp/modules/streams/services/stream_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/auth_controller.dart';

class StreamListScreen extends StatefulWidget {
  const StreamListScreen({super.key});

  @override
  State<StreamListScreen> createState() => _StreamListScreenState();
}

class _StreamListScreenState extends State<StreamListScreen> {
  late final StreamsListScreenController ctrl;

  List<StreamModel> _allStreams = [];
  String? _selectedStatus;
  String _searchLocation = '';

  @override
  void initState() {
    super.initState();
    final auth = Get.find<AuthController>();
    final user = auth.user.value;

    ctrl = Get.put(
      StreamsListScreenController(
        streamService: StreamService(baseUrl: AppConfig.apiBaseUrl),
        companyId: user!.employee!.company!.companyId,
        token: auth.token.value,
      ),
    );

    ctrl.loadStreams();
    _allStreams = ctrl.streams;
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
        DataCell(SelectableText(item.location ?? "-")),
        DataCell(SelectableText(item.model ?? "-")),
        DataCell(
          Icon(
            item.isActive == true ? Icons.check : Icons.close,
            color: item.isActive == true ? Colors.green : Colors.red,
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
            child: Text(item.currentStatus ?? "-"),
          ),
        ),
        DataCell(
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 150),
            child: Text(item.formattedLastStatus),
          ),
        ),
        DataCell(Text(item.shouldStream == true ? "Sim" : "Não")),
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

  List<StreamModel> _filteredStreams() {
    return _allStreams.where((s) {
      final matchesLocation = s.location.toLowerCase().contains(_searchLocation.toLowerCase());
      final matchesStatus = _selectedStatus == null || s.currentStatus == _selectedStatus;
      return matchesLocation && matchesStatus;
    }).toList();
  }

  Widget _buildFilters() {
    return Row(
      children: [
        // Filtro por localização
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Filtrar por localização',
              border: OutlineInputBorder(),
              isDense: true,
            ),
            onChanged: (value) {
              setState(() => _searchLocation = value);
            },
          ),
        ),
        const SizedBox(width: 16),

        // Filtro por status
        DropdownButton<String>(
          value: _selectedStatus,
          hint: const Text("Status da stream"),
          items: const [
            DropdownMenuItem(value: "REQUESTED", child: Text("REQUESTED")),
            DropdownMenuItem(value: "PROCESSING", child: Text("PROCESSING")),
          ],
          onChanged: (value) {
            setState(() => _selectedStatus = value);
          },
        ),
        const SizedBox(width: 16),

        // Botão limpar
        TextButton(
          onPressed: () {
            setState(() {
              _searchLocation = '';
              _selectedStatus = null;
            });
          },
          child: const Text("Limpar filtros"),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Streams cadastradas")),
      body: Obx(() {
        if (ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return GenericPaginatedTable<StreamModel>(
          title: "Streams",
          columns: _buildColumns(),
          rows: _filteredStreams(),
          rowBuilder: _rowBuilder,
          filters: _buildFilters(),
        );

      }),
    );
  }
}
