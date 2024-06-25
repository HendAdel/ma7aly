import 'package:flutter/material.dart';

class Ma7alyTable extends StatelessWidget {
  final List<DataColumn> columns;
  final DataTableSource source;

  const Ma7alyTable({required this.columns, required this.source, super.key});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        iconTheme: const IconThemeData(color: Colors.black, size: 26),
      ),
      child: PaginatedDataTable(
          onPageChanged: (index) {},
          showEmptyRows: false,
          horizontalMargin: 20,
          rowsPerPage: 10,
          checkboxHorizontalMargin: 12,
          columnSpacing: 20,
          showFirstLastButtons: true,
          // headingTextStyle: TextStyle(color: Colors.white, fontSize: 14),
          headingRowColor:
              MaterialStatePropertyAll(Theme.of(context).primaryColor),
          // border: TableBorder.all(color: Colors.black),
          // decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          // showBottomBorder: true,
          showCheckboxColumn: true,
          columns: columns,
          source: source),
    );
  }
}
