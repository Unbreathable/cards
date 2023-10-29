import 'package:cards/layouts/layout_manager.dart' as layout;
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/theme/fj_button.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ElementSidebar extends StatefulWidget {

  final layout.Element element;
  
  const ElementSidebar({super.key, required this.element});

  @override
  State<ElementSidebar> createState() => _ConversationAddWindowState();
}

class _ConversationAddWindowState extends State<ElementSidebar> {

  final _controller = TextEditingController();
  final settings = <layout.Setting>[];

  @override
  void dispose() {
    _controller.dispose();
    for(var setting in settings) {
      setting.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<EditorController>();

    return Padding(
      padding: const EdgeInsets.all(defaultSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      
          Text("Modify element", style: Get.theme.textTheme.titleMedium),
          verticalSpacing(defaultSpacing),
    
          ListView.builder(
            itemCount: widget.element.settings.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              final setting = widget.element.settings[index];
              final last = index == widget.element.settings.length - 1;
              settings.add(setting);

              if(!setting.exposed && controller.renderMode.value) {
                return Container();
              }
    
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                    visible: setting.showLabel,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: defaultSpacing),
                      child: Text(setting.description, style: Get.theme.textTheme.bodyMedium)
                    ),
                  ),
                  setting.build(context),
                  last ? Container() : verticalSpacing(defaultSpacing),
                ],
              );
            },
          ),
          
          verticalSpacing(defaultSpacing),
          FJElevatedButton(
            onTap: () {
              Get.find<EditorController>().save();
            }, 
            child: Center(child: Text("Save", style: Get.theme.textTheme.labelLarge)),
          )
        ],
      ),
    );
  }
}