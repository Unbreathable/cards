import 'package:cards/pages/main/cards_tab.dart';
import 'package:cards/pages/main/layout_add_dialog.dart';
import 'package:cards/pages/main/layouts_tab.dart';
import 'package:cards/theme/fj_button.dart';
import 'package:cards/theme/tab_button.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LayoutPage extends StatefulWidget {
  const LayoutPage({super.key});

  @override
  State<LayoutPage> createState() => _LayoutPageState();
}

class _LayoutPageState extends State<LayoutPage> {

  final selected = "Layouts".obs;

  final tabs = {
    "Layouts": const LayoutsTab(),
    "Cards": const CardsTab(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.colorScheme.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(defaultSpacing),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [          
                //* Tabs
                Row(
                  children: [
                    TabButton(
                      label: "Layouts",
                      selected: selected,
                      radius: const BorderRadius.only(
                        bottomLeft: Radius.circular(defaultSpacing),
                      ),
                      onTap: () {
                        selected.value = "Layouts";
                        
                      },
                    ),
                    horizontalSpacing(elementSpacing),
                    TabButton(
                      selected: selected,
                      label: "Cards",
                      radius: const BorderRadius.only(
                        topRight: Radius.circular(defaultSpacing),
                      ),
                      onTap: () {
                        selected.value = "Cards";
                        
                      }, 
                    ),
                  ],
                ),
          
                FJElevatedButton(
                  smallCorners: true,
                  onTap: () {
                    Get.dialog(const LayoutAddDialog());
                  }, 
                  child: Row(
                    children: [
                      Icon(Icons.add, color: Get.theme.colorScheme.onPrimary),
                      horizontalSpacing(elementSpacing),
                      Text("Add", style: Get.theme.textTheme.labelMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //* Actual tab
          Expanded(child: Obx(() => tabs[selected.value] ?? const Center(child: Text("Coming soon")))),
        ],
      )
    );
  }
}