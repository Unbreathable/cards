import 'package:cards/layouts/layout_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutsTab extends StatefulWidget {
  const LayoutsTab({super.key});

  @override
  State<LayoutsTab> createState() => _LayoutsTabState();
}

class _LayoutsTabState extends State<LayoutsTab> {

  final layouts = <Layout>[].obs;

  @override
  void initState() {
    loadLayouts();
    super.initState();
  }

  void loadLayouts() async {
    layouts.value = await LayoutManager.getLayouts();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {

      if(layouts.isEmpty) {
        return const Center(child: Text("No layouts found"));
      }

      return const Center(child: Text("layouts found"));
    });
  }
}