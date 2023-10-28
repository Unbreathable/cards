import 'package:cards/pages/editor/edit_layers_window.dart';
import 'package:cards/pages/editor/layer_add_window.dart';
import 'package:cards/pages/editor/sidebar/sidebar_element_tab.dart';
import 'package:cards/pages/editor/sidebar/sidebar_settings_tab.dart';
import 'package:cards/theme/tab_button.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditorSidebar extends StatefulWidget {
  const EditorSidebar({super.key});

  @override
  State<EditorSidebar> createState() => _EditorSidebarState();
}

class _EditorSidebarState extends State<EditorSidebar> {
  
  final GlobalKey _addKey = GlobalKey(), _editKey = GlobalKey();
  final _selected = "Layers".obs;
  
  final tabs = {
    "Layers": const SidebarElementTab(),
    "Settings": const SidebarSettingsTab(),
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TabButton(
              label: "Layers",
              selected: _selected,
              radius: const BorderRadius.only(
                bottomLeft: Radius.circular(defaultSpacing),
              ),
              onTap: () {
                _selected.value = "Layers";
                
              },
            ),
            horizontalSpacing(elementSpacing),
            TabButton(
              selected: _selected,
              label: "Settings",
              radius: const BorderRadius.only(
                topRight: Radius.circular(defaultSpacing),
              ),
              onTap: () {
                _selected.value = "Settings";
                
              }, 
            ),
            const Expanded(child: SizedBox()),
            Obx(() =>
              Visibility(
                visible: _selected.value == "Layers",
                child: IconButton(
                  key: _editKey,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    if(_selected.value == "Layers") {
                      final RenderBox box = _editKey.currentContext?.findRenderObject() as RenderBox;
                      Get.dialog(EditLayersWindow(position: box.localToGlobal(box.size.bottomLeft(const Offset(0, 5)))));
                    }
                  }, 
                ),
              )
            ),
            horizontalSpacing(elementSpacing),
            Obx(() =>
              Visibility(
                visible: _selected.value == "Layers",
                child: IconButton.filled(
                  key: _addKey,
                  color: Get.theme.colorScheme.onPrimary,
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if(_selected.value == "Layers") {
                      final RenderBox box = _addKey.currentContext?.findRenderObject() as RenderBox;
                      Get.dialog(LayerAddWindow(position: box.localToGlobal(box.size.bottomLeft(const Offset(0, 5)))));
                    }
                  }, 
                ),
              )
            ),
          ],
        ),

        //* Layers
        verticalSpacing(sectionSpacing),
        Expanded(
          child: Obx(() => tabs[_selected.value]!),
        )
      ],
    );
  }
}