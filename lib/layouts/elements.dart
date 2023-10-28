import 'package:cards/layouts/layout_manager.dart' as layout;
import 'package:cards/theme/list_selection.dart';
import 'package:flutter/material.dart';

class ImageElement extends layout.Element {
  
  ImageElement(String name) : super(name, 0, Icons.image);
  ImageElement.fromMap(int type, Map<String, dynamic> json) : super.fromMap(type, Icons.image, json);

  @override
  void init() {
    scalable = true;
    if(size.value.width == 0) size.value = const Size(100, 100);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.value.width,
      height: size.value.height,
      child: FlutterLogo(size: size.value.width)
    );
  }

  final iconMap = {
    BoxFit.contain: Icons.crop_square,
    BoxFit.cover: Icons.crop_5_4,
    BoxFit.fill: Icons.unfold_more,
    BoxFit.fitHeight: Icons.crop_16_9,
    BoxFit.fitWidth: Icons.crop_din,
    BoxFit.none: Icons.crop_free,
    BoxFit.scaleDown: Icons.crop_landscape
  };

  @override
  List<layout.Setting> buildSettings() {
    return [
      layout.Setting<String>("image", "Pick an image", layout.SettingType.file, true, null, ""),
      layout.SelectionSetting("fit", "Fit", true, BoxFit.values.indexOf(BoxFit.fill), 
        List.generate(BoxFit.values.length, (index) {
          final value = BoxFit.values[index];
          var formattedName = value.toString();
          for(var i = 0; i < formattedName.length; i++) {
            if(formattedName[i].toUpperCase() == formattedName[i]) {
              formattedName = "${formattedName.substring(0, i)} ${formattedName.substring(i).toLowerCase()}";
              i++;
            }
          }
          formattedName = formattedName.substring(0, 1).toUpperCase() + formattedName.substring(1);

          return SelectableItem(formattedName, iconMap[value]!);
        })
      )
    ];
  }
}

class TextElement extends layout.Element {
  
  TextElement(String name) : super(name, 1, Icons.text_fields);
  TextElement.fromMap(int type, Map<String, dynamic> json) : super.fromMap(type, Icons.text_fields, json);

  @override
  void init() {
    scalable = false;
  }

  @override
  Widget build(BuildContext context) {
    return Text("hello world");
  }

  @override
  List<layout.Setting> buildSettings() {
    return [];
  }
}