import 'package:epi_dash_mvp/common/config/app_config.dart';
import 'package:epi_dash_mvp/common/widgets/data_visualization/generic_paginated_data_table.dart';
import 'package:epi_dash_mvp/modules/admin/models/admin_stream_model.dart';
import 'package:epi_dash_mvp/modules/admin/services/admin_stream_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../auth/controllers/admin_auth_controller.dart';

class AdminStreamsListScreen extends StatefulWidget {
  const AdminStreamsListScreen({super.key});

  @override
  State<AdminStreamsListScreen> createState() => _AdminStreamsListScreenState();
}

class _AdminStreamsListScreenState extends State<AdminStreamsListScreen> {
  late Future<List<AdminStreamModel>> _streamsFuture;
  List<AdminStreamModel> _allStreams = [];

  String? _selectedStatus;
  String _searchLocation = '';

  @override
  void initState() {
    super.initState();
    _streamsFuture = _fetchAdminStreamModels();
  }

  Future<List<AdminStreamModel>> _fetchAdminStreamModels() async {
    final auth = Get.find<AdminAuthController>();
    final adminStreamService = AdminStreamService(baseUrl: AppConfig.apiBaseUrl);
    final fetched = await adminStreamService.fetchAllStreams(auth.token.value);
    _allStreams = fetched;
    return fetched;
  }

  List<AdminStreamModel> _filteredStreams() {
    return _allStreams.where((s) {
      final matchesLocation = s.cameraLocation.toLowerCase().contains(_searchLocation.toLowerCase());
      final matchesStatus = _selectedStatus == null || s.streamCurrentStatus == _selectedStatus;
      return matchesLocation && matchesStatus;
    }).toList();
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
      appBar: AppBar(title: const Text("Todas as Streams (Admin)")),
      body: FutureBuilder<List<AdminStreamModel>>(
        future: _streamsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          }

          return GenericPaginatedTable<AdminStreamModel>(
            title: "Streams Administrativas",
            columns: _buildColumns(),
            rows: _filteredStreams(),
            rowBuilder: _rowBuilder,
            filters: _buildFilters(),
          );
        },
      ),
    );
  }
}
