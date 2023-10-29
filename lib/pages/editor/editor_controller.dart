import 'package:cards/layouts/elements.dart';
import 'package:cards/layouts/layout_manager.dart';
import 'package:cards/pages/editor/element_settings/effect_error_dialog.dart';
import 'package:get/get.dart';

class EditorController extends GetxController {

  final currentLayout = Layout("name", "").obs;
  final currentElement = Rx<Element?>(null);
  final showSettings = false.obs;
  final renderMode = false.obs;

  final errorMessages = <String>[].obs;
  bool changed = false;
  final loading = false.obs;

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

  void redoLayout() async {
    loading.value = true;
    while(_doLayoutReorder()) {
      await Future.delayed(const Duration(milliseconds: 100));
    }
    loading.value = false;
  }

  bool _doLayoutReorder() {
    changed = false;
    errorMessages.clear();
    for(var layer in currentLayout.value.layers) {
      for(var element in layer.elements.values) {
        element.startLayout();
      }
    }

    for(var layer in currentLayout.value.layers) {
      for(var element in layer.elements.values) {
        element.preProcess();
        for(var effect in element.effects) {
          effect.preProcess(element);
        }
      }
    }

    for(var layer in currentLayout.value.layers) {
      for(var element in layer.elements.values) {
        element.applyLayout();
      }
    }

    if(errorMessages.isNotEmpty) {
      Get.dialog(const ErrorDialog());
    }
    save(layout: false);
    return changed;
  }

  void addElement(Layer layer, int type, String name) {
    Element? element;
    switch(type) {
      case 0: element = ImageElement(name); break;
      case 1: element = TextElement(name); break;
      case 2: element = BoxElement(name); break;
      case 3: element = ParagraphElement(name); break;
      case 4: element = HiderElement(name); break;
      default: throw Exception("Unknown element type: $type");
    }
    layer.addElement(element);
    save();
  }

  void deleteElement(Layer layer, Element element) {
    layer.elements.remove(element.id);
    save();
  }

  void save({bool layout = true}) {
    if(layout) {
      redoLayout();
      return;
    }
    if(renderMode.value) {
      LayoutManager.saveExportedLayout(currentLayout.value as ExportedLayout);
    } else {
      LayoutManager.saveLayout(currentLayout.value);
    }
  }

  void selectElement(Element element) {
    if(loading.value) return;
    currentElement.value = element;
  }

}