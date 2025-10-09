import 'package:flutter/material.dart';

class GenericPaginatedTable<T> extends StatelessWidget {
  final List<DataColumn> columns;
  final List<T> rows;
  final DataRow Function(T item) rowBuilder;
  final String title;
  final Widget? filters;
  final int rowsPerPage;

  const GenericPaginatedTable({
    super.key,
    required this.columns,
    required this.rows,
    required this.rowBuilder,
    required this.title,
    this.filters,
    this.rowsPerPage = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Filtros
        if (filters != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: filters!,
          ),

        // Tabela com largura completa
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              // ✅ Captura a largura disponível
              final availableWidth = constraints.maxWidth;

              return SingleChildScrollView(
                child: SizedBox(
                  // ✅ Força a tabela a ter pelo menos a largura da tela
                  width: availableWidth,
                  child: PaginatedDataTable(
                    header: Text(title),
                    columns: columns,
                    source: _GenericTableSource<T>(
                      rows: rows,
                      rowBuilder: rowBuilder,
                    ),
                    rowsPerPage: _calculateRowsPerPage(),
                    showCheckboxColumn: false,
                    columnSpacing: 20,
                    horizontalMargin: 16,
                    headingRowHeight: 56,
                    showFirstLastButtons: true,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  int _calculateRowsPerPage() {
    if (rows.isEmpty) return rowsPerPage;
    if (rows.length < rowsPerPage) return rows.length;
    return rowsPerPage;
  }
}

class _GenericTableSource<T> extends DataTableSource {
  final List<T> rows;
  final DataRow Function(T item) rowBuilder;

  _GenericTableSource({required this.rows, required this.rowBuilder});

  @override
  DataRow getRow(int index) {
    if (index >= rows.length) return const DataRow(cells: []);

    // ✅ Pegar a linha original
    final originalRow = rowBuilder(rows[index]);

    // ✅ Adicionar cor alternada (zebra)
    final isEven = index % 2 == 0;
    final backgroundColor = isEven ? Colors.grey.shade200 : Colors.white;

    return DataRow(
      cells: originalRow.cells,
      color: WidgetStateProperty.all(backgroundColor),
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}