import 'dart:io';

import 'package:cards/layouts/layout_manager.dart' as layout;
import 'package:cards/theme/list_selection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

    final path = settings[0].value.value as String;
    final fit = settings[1].value.value as int;
    final xOffset = settings[2].value.value as double;
    final yOffset = settings[3].value.value as double;

    return SizedBox(
      width: size.value.width,
      height: size.value.height,
      child: Image.file(File(path), fit: BoxFit.values[fit], alignment: AlignmentDirectional(xOffset, yOffset), errorBuilder: (context, error, stackTrace) {
        return Placeholder(
          color: Get.theme.colorScheme.error,
          child: Center(
            child: Text("Error loading image", style: Theme.of(context).textTheme.labelLarge),
          ),
        );
      },)
    );
  }

  final iconMap = {
    BoxFit.contain: Icons.crop_square,
    BoxFit.cover: Icons.crop_5_4,
    BoxFit.fill: Icons.crop_7_5,
    BoxFit.fitHeight: Icons.crop_16_9,
    BoxFit.fitWidth: Icons.crop_din,
    BoxFit.none: Icons.crop_free,
    BoxFit.scaleDown: Icons.crop_landscape
  };

  @override
  List<layout.Setting> buildSettings() {
    return [
      layout.FileSetting("image", "Pick an image", FileType.image, true),
      layout.SelectionSetting("fit", "Pick an image fit", true, BoxFit.values.indexOf(BoxFit.cover), 
        List.generate(BoxFit.values.length, (index) {
          final value = BoxFit.values[index];
          var formattedName = value.toString().split(".").last;
          for(var i = 0; i < formattedName.length; i++) {
            if(formattedName[i].toUpperCase() == formattedName[i]) {
              formattedName = "${formattedName.substring(0, i)} ${formattedName.substring(i).toLowerCase()}";
              i++;
            }
          }
          formattedName = formattedName.substring(0, 1).toUpperCase() + formattedName.substring(1);

          return SelectableItem(formattedName, iconMap[value]!);
        })
      ),
      layout.NumberSetting("x_offset", "X offset", true, 0.0, -1.0, 1.0),
      layout.NumberSetting("y_offset", "Y offset", true, 0.0, -1.0, 1.0),
    ];
  }
}

class TextElement extends layout.Element {
  
  TextElement(String name) : super(name, 1, Icons.text_fields);
  TextElement.fromMap(int type, Map<String, dynamic> json) : super.fromMap(type, Icons.text_fields, json);

  @override
  void init() {
    scalable = true;
    if(size.value.width == 0) size.value = const Size(100, 30);
  }

  @override
  Widget build(BuildContext context) {

    final text = settings[0].value.value as String;
    final align = settings[1].value.value as int;
    final fontSize = settings[2].value.value as double;
    final bold = settings[3].value.value as bool;
    final italic = settings[4].value.value as bool;

    return SizedBox(
      width: size.value.width,
      height: size.value.height,
      child: Text(text, style: TextStyle(fontSize: fontSize, fontWeight: bold ? FontWeight.bold : FontWeight.normal, fontStyle: italic ? FontStyle.italic : FontStyle.normal), textAlign: alignmentMap[align],),
    );
  }

  final alignmentMap = {
    0: TextAlign.left,
    1: TextAlign.center,
    2: TextAlign.right
  };

  @override
  List<layout.Setting> buildSettings() {
    return [
      layout.TextSetting("text", "Text", true, "Some text"),
      layout.SelectionSetting("align", "Text alignment", false, 0, 
        [
          const SelectableItem("Left", Icons.format_align_left),
          const SelectableItem("Center", Icons.format_align_center),
          const SelectableItem("Right", Icons.format_align_right),
        ]
      ),
      layout.NumberSetting("size", "Font size", false, 20.0, 15.0, 50.0),
      layout.BoolSetting("bold", "Bold", false, false),
      layout.BoolSetting("italic", "Italic", false, false),
    ];
  }
}