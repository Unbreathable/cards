import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/pages/editor/element_add_window.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class SidebarElementTab extends StatefulWidget {
  const SidebarElementTab({super.key});

  @override
  State<SidebarElementTab> createState() => _SidebarElementTabState();
}

class _SidebarElementTabState extends State<SidebarElementTab> {
  @override
  Widget build(BuildContext context) {
    return GetX<EditorController>(
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
            
                        Visibility(
                          visible: !controller.renderMode.value,
                          child: IconButton(
                            key: addKey,
                            onPressed: () {
                              final RenderBox box = addKey.currentContext?.findRenderObject() as RenderBox;
                              Get.dialog(ElementAddWindow(layer: layer, position: box.localToGlobal(box.size.bottomLeft(const Offset(0, 5)))));
                            }, 
                            icon: const Icon(Icons.add)
                          ),
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
                                            Visibility(
                                              visible: !controller.renderMode.value,
                                              replacement: IconButton(
                                                onPressed: () {},
                                                icon: const Icon(Icons.delete, color: Colors.transparent)
                                              ),
                                              child: IconButton(
                                                onPressed: () {
                                                  controller.deleteElement(layer, layer.elements[index]);
                                                }, 
                                                icon: const Icon(Icons.delete)
                                              ),
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
    );
  }
}