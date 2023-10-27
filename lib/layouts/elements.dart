import 'package:cards/layouts/layout_manager.dart' as layout;
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

  @override
  void buildSettings(BuildContext context) {
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
  void buildSettings(BuildContext context) {
  }
}