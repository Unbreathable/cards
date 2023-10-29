import 'package:cards/layouts/layout_manager.dart';
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/pages/renderer/renderer_page.dart';
import 'package:cards/theme/fj_button.dart';
import 'package:cards/theme/fj_textfield.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class LayoutExportDialog extends StatefulWidget {
  const LayoutExportDialog({super.key});

  @override
  State<LayoutExportDialog> createState() => _LayoutAddDialogState();
}

class _LayoutAddDialogState extends State<LayoutExportDialog> {

  final _controller = TextEditingController();
  final _error = Rx<String?>(null);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 380,
        child: Animate(
          effects: [
            ScaleEffect(
              duration: 500.ms,
              begin: const Offset(0, 0),
              end: const Offset(1, 1),
              curve: const ElasticOutCurve(0.9),
            )
          ],
          child: Material(
            elevation: 2.0,
            color: Get.theme.colorScheme.onBackground,
            borderRadius: BorderRadius.circular(dialogBorderRadius),
            child: Padding(
              padding: const EdgeInsets.all(dialogPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Export layout", style: Get.theme.textTheme.titleMedium),
                  verticalSpacing(sectionSpacing),
          
                  verticalSpacing(defaultSpacing),
                  Text("Name of the export", style: Get.theme.textTheme.bodyMedium),
                  verticalSpacing(defaultSpacing),

                  Obx(() =>
                    FJTextField(
                      controller: _controller,
                      hintText: "Exported name",
                      errorText: _error.value,
                    )
                  ),
                  verticalSpacing(defaultSpacing),
                  FJElevatedButton(
                    onTap: () async {
                      if(_controller.text.length < 3) {
                        _error.value = "Must be at least 3 characters long.";
                        return;
                      }

                      await LayoutManager.exportLayout(Get.find<EditorController>().currentLayout.value, _controller.text);
                      Get.back();
                      Get.off(RendererPage(name: _controller.text));
                    }, 
                    child: Center(child: Text("Export", style: Get.theme.textTheme.labelLarge)),
                  )
                ],
              ),
            )
          ),
        ),
      ),
    );
  }
}