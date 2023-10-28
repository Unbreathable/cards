import 'package:cards/pages/editor/edit_layers_window.dart';
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/pages/editor/element_add_window.dart';
import 'package:cards/pages/editor/layer_add_window.dart';
import 'package:cards/theme/tab_button.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class EditorSidebar extends StatefulWidget {
  const EditorSidebar({super.key});

  @override
  State<EditorSidebar> createState() => _EditorSidebarState();
}

class _EditorSidebarState extends State<EditorSidebar> {
  
  final GlobalKey _addKey = GlobalKey(), _editKey = GlobalKey();
  final _selected = "Layers".obs;
  
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
          child: GetX<EditorController>(
            builder: (controller) {
              return ListView.builder(
                itemCount: controller.currentLayout.value.layers.length,
                itemBuilder: (context, index) {
                  final layer = controller.currentLayout.value.layers[index];
        
                  return Padding(
                    padding: const EdgeInsets.only(bottom: sectionSpacing),
                    child: Obx(() {
                      final expanded = layer.expanded.value;
                      final GlobalKey addKey = GlobalKey();
                  
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Animate(
                                effects: [
                                  RotateEffect(
                                    duration: 100.ms,
                                    begin: -0.25,
                                    end: 0,
                                    alignment: Alignment.center,
                                  )
                                ],
                                target: expanded ? 1 : 0,
                                child: IconButton(
                                  onPressed: () {
                                    layer.expanded.value = !layer.expanded.value;
                                  }, 
                                  icon: const Icon(Icons.expand_more)
                                ),
                              ),
                              horizontalSpacing(elementSpacing),
                              Text(layer.name, style: Get.theme.textTheme.labelMedium, textHeightBehavior: noTextHeight,),
                              const Expanded(child: SizedBox()),
                  
                              IconButton(
                                key: addKey,
                                onPressed: () {
                                  final RenderBox box = addKey.currentContext?.findRenderObject() as RenderBox;
                                  Get.dialog(ElementAddWindow(layer: layer, position: box.localToGlobal(box.size.bottomLeft(const Offset(0, 5)))));
                                }, 
                                icon: const Icon(Icons.add)
                              ),
                            ],
                          ),
                  
                          Visibility(
                            visible: expanded,
                            child: Padding(
                              padding: const EdgeInsets.only(left: sectionSpacing),
                              child: Obx(() =>
                                ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: layer.elements.length,
                                  itemBuilder: (context, index) {
                                    final element = layer.elements[index];
                            
                                    return Padding(
                                      padding: const EdgeInsets.only(top: elementSpacing),
                                      child: Obx(() =>
                                        Material(
                                          borderRadius: BorderRadius.circular(defaultSpacing),
                                          color: controller.currentElement.value == layer.elements[index] ? Get.theme.colorScheme.primary : Colors.transparent,
                                          child: InkWell(
                                            borderRadius: BorderRadius.circular(defaultSpacing),
                                            onTap: () {
                                              controller.selectElement(layer.elements[index]);
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.all(elementSpacing),
                                              child: Row(
                                                children: [
                                                  Icon(element.icon, color: controller.currentElement.value == layer.elements[index] ? Get.theme.colorScheme.onPrimary : Get.theme.colorScheme.onSurface,),
                                                  horizontalSpacing(elementSpacing),
                                                  Text(layer.elements[index].name, style: controller.currentElement.value == layer.elements[index] ? Get.theme.textTheme.labelMedium : Get.theme.textTheme.bodyMedium, textHeightBehavior: noTextHeight,),
                                                  const Expanded(child: SizedBox()),
                                                  IconButton(
                                                    onPressed: () {
                                                      controller.deleteElement(layer, layer.elements[index]);
                                                    }, 
                                                    icon: const Icon(Icons.delete)
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ),
                                    );
                                  },
                                )
                              ),
                            )
                          )
                        ],
                      );
                    }),
                  );
                },
              );
            },
          ),
        )
      ],
    );
  }
}