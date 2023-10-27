import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

part 'layout_objects.dart';

class LayoutManager {

  static void saveLayout(Layout layout) {
  }

  static void loadLayout(String path) {
    
  }

  static Future<List<Layout>> getLayouts() async {
    final path = await getApplicationSupportDirectory();
    final directory = await Directory("${path.path}/layouts").create();
    
    for(var element in directory.listSync(followLinks: false)) {
      if(element is File) {
        print(element.path);
      }
    }
    
    return [];
  }

}