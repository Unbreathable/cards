part of 'layout_manager.dart';

class Layout {
  final String name;
  final String path;
  late final int width, height;
  late final layers = RxList<Layer>();

  Layout(this.name, this.path) {
    width = 0;
    height = 0;
  }
  Layout.create(this.name, this.path, this.width, this.height);
  Layout.fromMap(this.path, Map<String, dynamic> json) : name = json["name"], width = json["width"], height = json["height"] {
    for(var layer in json["layers"]) {
      layers.add(Layer.fromMap(layer));
    }
  }
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> layersMap = [];
    for(var layer in layers) {
      layersMap.add(layer.toMap());
    }
    return {
      "name": name,
      "width": width,
      "height": height,
      "layers": layersMap
    };
  }
}

class Layer {
  final String name;
  late final elements = RxList<Element>();
  final expanded = true.obs;

  Layer(this.name);
  Layer.fromMap(Map<String, dynamic> json) : name = json["name"] {
    for(var element in json["elements"]) {
      elements.add(LayoutManager.getElementFromMap(this, element));
    }
  }
  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> elementsMap = [];
    for(var element in elements) {
      final map = element.toMap();
      map["type"] = element.type;
      elementsMap.add(map);
    }
    return {
      "name": name,
      "elements": elementsMap
    };
  }
}

abstract class Element {
  final int type;
  final String name;
  final IconData icon;
  Layer parent = Layer("");
  bool scalable = false;
  final position =  const Offset(0, 0).obs;
  final size = const Size(0, 0).obs;
  late final Map<String, dynamic> settings;

  Element(this.name, this.type, this.icon) {
    settings = {};
    init();
  }
   Element.fromMap(this.type, this.icon, Map<String, dynamic> json) : name = json["name"] {
    settings = json["settings"];
    position.value = Offset(json["x"], json["y"]);
    size.value = Size(json["width"], json["height"]);
    init();
  }
  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "x": position.value.dx,
      "y": position.value.dy,
      "width": size.value.width,
      "height": size.value.height,
      "settings": settings
    };
  }

  void init();
  void buildSettings(BuildContext context);
  Widget build(BuildContext context);
}