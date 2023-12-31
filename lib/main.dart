import 'package:cards/layouts/layout_manager.dart';
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/pages/main/layout_page.dart';
import 'package:cards/theme/color_generator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  
  await LayoutManager.getLayouts();
  Get.put(EditorController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.topLevel,
      debugShowCheckedModeBanner: false,
      title: 'Cards app',
      theme: getThemeData(context),
      home: const LayoutPage()
    );
  }
}
