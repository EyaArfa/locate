import 'package:find_me/services/data.dart';
import 'package:flutter/material.dart';

class ListBestPosition extends StatefulWidget {
  const ListBestPosition({super.key});

  @override
  State<ListBestPosition> createState() => _ListBestPositionState();
}

class _ListBestPositionState extends State<ListBestPosition> {
  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      // itemCount: ,
      itemBuilder: (context, index) => Text(''),
    );
  }
}
