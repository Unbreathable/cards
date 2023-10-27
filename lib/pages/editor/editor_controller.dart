import 'package:cards/layouts/elements.dart';
import 'package:cards/layouts/layout_manager.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {

  final currentLayout = Layout("name", "").obs;
  final currentElement = Rx<Element?>(null);

  void setCurrentLayout(Layout layout) {
    currentLayout.value = layout;
  }

  void addLayer(Layer layer) {
    currentLayout.value.layers.add(layer);
    save();
  }

  void addElement(Layer layer, int type, String name) {
    Element? element;
    switch(type) {
      case 0: element = ImageElement(name); break;
      case 1: element = TextElement(name); break;
      default: throw Exception("Unknown element type: $type");
    }
    layer.elements.add(element);
    save();
  }

  void deleteElement(Layer layer, Element element) {
    layer.elements.remove(element);
    save();
  }

  void save() {
    LayoutManager.saveLayout(currentLayout.value);
  }

  void selectElement(Element element) {
    currentElement.value = element;
  }

}