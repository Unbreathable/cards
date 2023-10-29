import 'package:cards/layouts/layout_manager.dart' as layout;
import 'package:cards/pages/editor/editor_controller.dart';
import 'package:cards/theme/list_selection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

Effect effectFromMap(Map<String, dynamic> json) {
  final type = json["type"];
  switch(type) {
    case 0: return PaddingEffect.fromMap(json);
    case 1: return AlignmentEffect.fromMap(json);
    case 2: return InheritSizeEffect.fromMap(json);
    case 3: return InheritPositionEffect.fromMap(json);
    default: throw Exception("Unknown effect type: $type");
  }
}

abstract class Effect {
  final int type;
  final String name;
  final IconData icon;
  late final List<layout.Setting> settings;
  final enabled = false.obs;
  final expanded = false.obs;

  Effect(this.type, this.name, this.icon) {
    settings = buildSettings();
  }
  Effect.fromMap(this.name, this.icon, Map<String, dynamic> json) : type = json["type"] {
    settings = buildSettings();
    for(var setting in settings) {
      setting.fromJson(json["settings"]);
    }
  }

  Map<String, dynamic> toMap() {
    var json = <String, dynamic>{};
    json["type"] = type;
    final settingsMap = <String, dynamic>{};
    for(var setting in settings) {
      setting.intoJson(settingsMap);
    }
    json["settings"] = settingsMap;
    return json;
  }

  List<layout.Setting> buildSettings();
  void preProcess(layout.Element element) {}
  Widget apply(layout.Element element, Widget child) { return child; }
}

//* Effects
class PaddingEffect extends Effect {

  final padding = layout.NumberSetting("padding", "Padding", false, 0.0, 0.0, 50.0);

  PaddingEffect() : super(0, "Padding", Icons.padding);
  PaddingEffect.fromMap(Map<String, dynamic> json) : super.fromMap("Padding", Icons.padding, json);

  @override
  List<layout.Setting> buildSettings() {
    return [padding];
  }

  @override
  void preProcess(layout.Element element) {}

  @override
  Widget apply(layout.Element element, Widget child) {
    return Padding(
      padding: EdgeInsets.all(padding.value.value ?? 0.0),
      child: child,
    );
  }
}

class AlignmentEffect extends Effect {

  final xAlignment = layout.SelectionSetting("alignX", "X Alignment", false, 0, 
    [
      const SelectableItem("None", Icons.close),
      const SelectableItem("Left", Icons.align_horizontal_left),
      const SelectableItem("Center", Icons.align_horizontal_center),
      const SelectableItem("Right", Icons.align_horizontal_right),
    ]
  );
  final yAlignment = layout.SelectionSetting("alignY", "Y Alignment", false, 0, 
    [
      const SelectableItem("None", Icons.close),
      const SelectableItem("Top", Icons.align_vertical_top),
      const SelectableItem("Center", Icons.align_vertical_center),
      const SelectableItem("Bottom", Icons.align_vertical_bottom),
    ]
  );

  AlignmentEffect() : super(1, "Alignment", Icons.zoom_out_map);
  AlignmentEffect.fromMap(Map<String, dynamic> json) : super.fromMap("Alignment", Icons.zoom_out_map, json);

  @override
  List<layout.Setting> buildSettings() {
    return [xAlignment, yAlignment];
  }

  @override
  void preProcess(layout.Element element) {
    final controller = Get.find<EditorController>();
    final alignX = xAlignment.value.value as int;
    final alignY = yAlignment.value.value as int;
    element.lockX = alignX != 0;
    element.lockY = alignY != 0;

    switch(alignX) {
      case 1: element.position.value = Offset(0, element.position.value.dy); break;
      case 2: element.position.value = Offset((controller.currentLayout.value.width - element.size.value.width) / 2, element.position.value.dy); break;
      case 3: element.position.value = Offset(controller.currentLayout.value.width - element.size.value.width - 2, element.position.value.dy); break;
    }

    switch(alignY) {
      case 1: element.position.value = Offset(element.position.value.dx, 0); break;
      case 2: element.position.value = Offset(element.position.value.dx, (controller.currentLayout.value.height - element.size.value.height) / 2); break;
      case 3: element.position.value = Offset(element.position.value.dx, controller.currentLayout.value.height - element.size.value.height - 2); break;
    }
  }
}

class InheritSizeEffect extends Effect {

  final element = layout.ElementSetting("element", "Element", false);

  InheritSizeEffect() : super(2, "Inherit size", Icons.crop_square);
  InheritSizeEffect.fromMap(Map<String, dynamic> json) : super.fromMap("Inherit size", Icons.crop_square, json);

  @override
  List<layout.Setting> buildSettings() {
    return [element];
  }

  @override
  void preProcess(layout.Element element) {
    final target = this.element.value.value as String;

    // Find element
    final controller = Get.find<EditorController>();
    layout.Element? parent;
    for(var layer in controller.currentLayout.value.layers) {
      for(var eId in layer.elements.keys.toList()) {
        if(eId == target) {
          parent = layer.elements[eId]!;
          break;
        }
      }
    }

    element.size.value = (parent ?? element).size.value;
  }

}

class InheritPositionEffect extends Effect {

  final element = layout.ElementSetting("element", "Element", false);

  InheritPositionEffect() : super(3, "Inherit position", Icons.radar);
  InheritPositionEffect.fromMap(Map<String, dynamic> json) : super.fromMap("Inherit position", Icons.radar, json);

  @override
  List<layout.Setting> buildSettings() {
    return [element];
  }

  @override
  void preProcess(layout.Element element) {
    final target = this.element.value.value as String;

    // Find element
    final controller = Get.find<EditorController>();
    layout.Element? parent;
    for(var layer in controller.currentLayout.value.layers) {
      for(var eId in layer.elements.keys.toList()) {
        if(eId == target) {
          parent = layer.elements[eId]!;
          break;
        }
      }
    }

    element.position.value = (parent ?? element).position.value;
  }

}