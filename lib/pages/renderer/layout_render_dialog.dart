import 'dart:io';

import 'package:cards/pages/editor/editor_canvas.dart';
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/theme/fj_button.dart';
import 'package:cards/theme/fj_textfield.dart';
import 'package:cards/theme/success_container.dart';
import 'package:cards/theme/vertical_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';

class LayoutRenderDialog extends StatefulWidget {
  const LayoutRenderDialog({super.key});

  @override
  State<LayoutRenderDialog> createState() => _LayoutAddDialogState();
}

class _LayoutAddDialogState extends State<LayoutRenderDialog> {

  final _controller = TextEditingController(), _width = TextEditingController(), _height = TextEditingController();
  final _error = Rx<String?>(null);
  final revealSuccess = false.obs;

  @override
  void dispose() {
    _controller.dispose();
    _width.dispose();
    _height.dispose();
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

                  Text("Render the card", style: Get.theme.textTheme.titleMedium),
                  verticalSpacing(sectionSpacing),

                  Obx(() =>
                    Animate(
                      effects: [
                        CustomEffect(
                          duration: 250.ms,
                          builder: (context, value, child) {
                            return SizedBox(
                              height: (50 + defaultSpacing) * value,
                              child: child,
                            );
                          },
                        ),
                        ScaleEffect(
                          begin: const Offset(0.0, 0.0),
                          end: const Offset(1.0, 1.0),
                          duration: 500.ms,
                          curve: const ElasticOutCurve(0.9),
                          delay: 250.ms,
                        )
                      ],
                      target: revealSuccess.value ? 1 : 0,
                      child: const Padding(
                        padding: EdgeInsets.only(bottom: defaultSpacing),
                        child: SuccessContainer(text: "Rendered successfully!"),
                      ),
                    )
                  ),
          
                  Text("Size of the final output", style: Get.theme.textTheme.bodyMedium),
                  verticalSpacing(defaultSpacing),

                  Obx(() =>
                    FJTextField(
                      controller: _controller,
                      hintText: "Final width",
                      errorText: _error.value,
                    )
                  ),
                  verticalSpacing(defaultSpacing),
                  FJElevatedButton(
                    onTap: () async {
                      revealSuccess.value = false;
                      final width = int.tryParse(_controller.text);
                      if(width == null) {
                        _error.value = "Width and height must be numbers.";
                        return;
                      }
                      final controller = Get.find<EditorController>();
                      controller.currentElement.value = null;
                      final scale = width / controller.currentLayout.value.width;

                      final screenshotController = ScreenshotController();
                      final image = await screenshotController.captureFromWidget(
                        const EditorCanvas(),
                        pixelRatio: scale,
                      );
                      final path = await getDownloadsDirectory();
                      await File("${path!.path}\\render-${controller.currentLayout.value.name}.png").writeAsBytes(image);
                      revealSuccess.value = true;
                    }, 
                    child: Center(child: Text("Render", style: Get.theme.textTheme.labelLarge)),
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