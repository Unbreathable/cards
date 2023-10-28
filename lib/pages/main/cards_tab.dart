import 'package:cards/layouts/layout_manager.dart';
import 'package:cards/pages/editor/editor_page.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});

  @override
  State<CardsTab> createState() => _LayoutsTabState();
}

class _LayoutsTabState extends State<CardsTab> {

  final _loading = true.obs;
  final _layouts = <String>[].obs;

  @override
  void initState() {
    loadLayouts();
    super.initState();
  }

  void loadLayouts() async {
    _layouts.value = await LayoutManager.getLayouts();
    _loading.value = false;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Render some cards and come back.")
    );
  }
}