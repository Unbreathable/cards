part of 'layout_manager.dart';

class Layout {
  final String name;
  final String path;
  late final List<Layer> layers;

  Layout(this.name, this.path) {
    layers = [];
  }
  Layout.fromMap(this.path, Map<String, dynamic> json) : name = json["name"] {
    for(var layer in json["layers"]) {
      layers.add(Layer.fromMap(layer));
    }
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "layers": layers
    };
  }
}

class Layer {
  final String name;
  late final List<Parent> parents;

  Layer(this.name) {
    parents = [];
  }
  Layer.fromMap(Map<String, dynamic> json) : name = json["name"] {
    for(var parent in json["parents"]) {
      parents.add(Parent.fromMap(parent));
    }
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "parents": parents
    };
  }
}

class Parent {
  final String name;
  late final List<Element> children;
  late final Map<String, dynamic> settings;

  Parent(this.name) {
    children = [];
    settings = {};
  }
  Parent.fromMap(Map<String, dynamic> json) : name = json["name"] {
    children = json["children"];
    settings = json["settings"];
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "children": children,
      "settings": settings
    };
  }
}

abstract class Element {
  final String name;
  late final Map<String, dynamic> settings;

  Element(this.name) {
    settings = {};
    init();
  }
  Element.fromMap(Map<String, dynamic> json) : name = json["name"] {
    settings = json["settings"];
    init();
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "settings": settings
    };
  }

  void init();
  void buildSettings(BuildContext context);
  void build(BuildContext context);
}