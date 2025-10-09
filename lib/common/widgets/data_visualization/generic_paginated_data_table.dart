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
      children: [
        if (filters != null)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: filters!,
          ),
        Expanded(
          child: SingleChildScrollView(
            child: PaginatedDataTable(
              header: Text(title),
              columns: columns,
              source: _GenericTableSource<T>(
                rows: rows,
                rowBuilder: rowBuilder,
              ),
              rowsPerPage: rowsPerPage,
            ),
          ),
        ),
      ],
    );
  }
}

class _GenericTableSource<T> extends DataTableSource {
  final List<T> rows;
  final DataRow Function(T item) rowBuilder;

  _GenericTableSource({required this.rows, required this.rowBuilder});

  @override
  DataRow getRow(int index) {
    if (index >= rows.length) return const DataRow(cells: []);
    return rowBuilder(rows[index]);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => rows.length;

  @override
  int get selectedRowCount => 0;
}
