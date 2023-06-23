import 'package:flutter/material.dart';

class ItemOverviewScreen extends StatefulWidget {

  const ItemOverviewScreen({super.key});

  @override
  State<ItemOverviewScreen> createState() => _CreateOverviewState();
}

class _CreateOverviewState extends State<ItemOverviewScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Create location memory'),
    ),
    body: SingleChildScrollView(
    child: Column(
    ),
    ),
    );
  }
}