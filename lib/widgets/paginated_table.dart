import 'package:flutter/material.dart';

class PaginatedTable extends StatefulWidget {
  PaginatedTable({Key key, this.columns, this.rows}) : super(key: key);
  final List columns;
  final List rows;

  @override
  _PaginatedTableState createState() => _PaginatedTableState();
}

class _PaginatedTableState extends State<PaginatedTable> {
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: widget.columns,
      rows: widget.rows,
    );
  }
}
