import 'package:cards/layouts/elements.dart';
import 'package:cards/layouts/layout_manager.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {

  final currentLayout = Layout("name", "").obs;
  final currentElement = Rx<Element?>(null);
  final showSettings = false.obs;
  final renderMode = false.obs;

  void setCurrentLayout(Layout layout) {
    showSettings.value = false;
    currentElement.value = null;
    currentLayout.value = layout;
    renderMode.value = false;
  }

  void loadFromExported(ExportedLayout layout) {
    showSettings.value = false;
    currentElement.value = null;
    currentLayout.value = layout;
    renderMode.value = true;
  }

  void deleteLayer(Layer layer) {
    currentLayout.value.layers.remove(layer);
    save();
  }

  void reorderLayer(int oldIndex, int newIndex) {
    final layer = currentLayout.value.layers.removeAt(oldIndex);
    if(newIndex > oldIndex) newIndex--;
    currentLayout.value.layers.insert(newIndex, layer);
    save();
  }

  void addLayer(Layer layer) {
    currentLayout.value.layers.insert(0, layer);
    save();
  }

  void addElement(Layer layer, int type, String name) {
    Element? element;
    switch(type) {
      case 0: element = ImageElement(name); break;
      case 1: element = TextElement(name); break;
      case 2: element = BoxElement(name); break;
      case 3: element = ParagraphElement(name); break;
      default: throw Exception("Unknown element type: $type");
    }
    layer.addElement(element);
    save();
  }

  void deleteElement(Layer layer, Element element) {
    layer.elements.remove(element.id);
    save();
  }

  void save() {
    if(renderMode.value) {
      LayoutManager.saveExportedLayout(currentLayout.value as ExportedLayout);
    } else {
      LayoutManager.saveLayout(currentLayout.value);
    }
  }

  void selectElement(Element element) {
    currentElement.value = element;
  }

}