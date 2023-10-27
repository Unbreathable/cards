import 'dart:convert';
import 'dart:io';

import 'package:cards/layouts/elements.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';

part 'layout_objects.dart';

class LayoutManager {

  /// Gets an element from a map (returns an [Element] or throws an [Exception])
  static Element getElementFromMap(Layer layer, Map<String, dynamic> json) {
    final type = json["type"];
    switch(type) {
      case 0: return ImageElement.fromMap(type, json);
      case 1: return TextElement.fromMap(type, json);
      default: throw Exception("Unknown element type: $type");
    }
  }

  static Future<String> _getPath() async {
    final path = await getApplicationSupportDirectory();
    final directory = await Directory("${path.path}/layouts").create();
    return directory.path;
  }

  static Future<bool> saveLayout(Layout layout) async {
    final path = await _getPath();
    final map = layout.toMap();
    final file = File("$path/${layout.name}.lay");
    await file.writeAsString(jsonEncode(map));
    return true;
  }

  static Future<Layout> loadLayout(String name) async {
    final path = await _getPath();
    final file = File("$path/$name.lay");
    final json = jsonDecode(await file.readAsString());
    return Layout.fromMap(file.path, json);
  }

  static Future<List<String>> getLayouts() async {
    final directory = Directory(await _getPath());
    final layouts = <String>[];
    for(var element in directory.listSync(followLinks: false)) {
      if(element is File) {
        final file = File(element.path);
        final filePath = file.path.split("/").last;
        final args = filePath.split("\\");
        var name = args.last;
        if(name.endsWith(".lay")) {
          name = name.substring(0, name.length - 4);
          layouts.add(name);
        }
      }
    }
    
    return layouts;
  }

}