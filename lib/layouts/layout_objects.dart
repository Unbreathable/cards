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
  late final List<Setting> settings;

  Element(this.name, this.type, this.icon) {
    settings = buildSettings();
    init();
  }
   Element.fromMap(this.type, this.icon, Map<String, dynamic> json) : name = json["name"] {
    settings = [];
    for(var setting in buildSettings()) {
      setting.fromJson(json["settings"]);
      settings.add(setting);
    }
    position.value = Offset(json["x"], json["y"]);
    size.value = Size(json["width"], json["height"]);
    init();
  }
  Map<String, dynamic> toMap() {

    final settingsMap = <String, dynamic>{};
    for(var setting in settings) {
      setting.intoJson(settingsMap);
    }

    return {
      "name": name,
      "x": position.value.dx,
      "y": position.value.dy,
      "width": size.value.width,
      "height": size.value.height,
      "settings": settingsMap
    };
  }

  void init();
  List<Setting> buildSettings();
  Widget build(BuildContext context);
}

enum SettingType {
  number,
  text,
  selection,
  file
}

abstract class Setting<T> {
  
  final String name;
  final String description;
  final SettingType type;

  /// Whether this setting should be exposed to the user when this is a template
  final bool exposed;
  final T _defaultValue;
  final value = Rx<T?>(null);
 
  // Configuration
  bool showLabel = true;
 
  Setting(this.name, this.description, this.type, this.exposed, this._defaultValue) {
    value.value = _defaultValue;
    init();
  }

  void setValue(T newVal) {
    value.value = newVal;
  }

  void fromJson(Map<String, dynamic> json) {
    if (json.containsKey(name)) {
      value.value = json[name];
    }
  }

  void intoJson(Map<String, dynamic> json) {
    if(value.value != null) {
      json[name] = value.value;
    }
  }

  void init() {}
  Widget build(BuildContext context);
  void dispose() {}
}

class TextSetting extends Setting<String> {
  TextSetting(String name, String description, bool exposed, String def) : super(name, description, SettingType.selection, exposed, def);

  TextEditingController? _controller;

  @override
  void dispose() {
    if(_controller == null) return;
    _controller!.dispose();
    _controller = null;
  }

  @override
  Widget build(BuildContext context) {
    _controller = TextEditingController();
    _controller!.text = value.value ?? _defaultValue;
    _controller!.addListener(() {
      setValue(_controller!.text);
    });
    return FJTextField(
      controller: _controller,
      hintText: "Value",
    );
  }
}

class NumberSetting extends Setting<double> {

  final double min, max;

  NumberSetting(String name, String description, bool exposed, double def, this.min, this.max) : super(name, description, SettingType.selection, exposed, def);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>
      Slider(
        value: clampDouble(value.value ?? _defaultValue, min, max),
        focusNode: FocusNode(),
        inactiveColor: Get.theme.colorScheme.primary,
        thumbColor: Get.theme.colorScheme.onPrimary,
        activeColor: Get.theme.colorScheme.onPrimary,
        min: min,
        max: max,
        onChanged: (newVal) => setValue(newVal),  
      )
    );
  }
}

class BoolSetting extends Setting<bool> {

  BoolSetting(String name, String description, bool exposed, bool def) : super(name, description, SettingType.selection, exposed, def);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(description, style: Get.theme.textTheme.bodyMedium, overflow: TextOverflow.ellipsis,)),
        horizontalSpacing(elementSpacing),
        Obx(() =>
          Switch(
            activeColor: Get.theme.colorScheme.secondary,
            trackColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Get.theme.colorScheme.primary : Get.theme.colorScheme.primaryContainer),
            hoverColor: Get.theme.hoverColor,
            thumbColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? Get.theme.colorScheme.onPrimary : Get.theme.colorScheme.surface),
            value: value.value ?? _defaultValue,
            onChanged: (newVal) => setValue(newVal),  
          )
        ),
      ],
    );
  }

  @override
  void init() {
    showLabel = false;
  }
}

class FileSetting extends Setting<String> {
  final fp.FileType fileType;
  FileSetting(String name, String description, this.fileType, bool exposed) : super(name, description, SettingType.file, exposed, "");

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(fileType == fp.FileType.image ? Icons.image : Icons.note, color: Get.theme.colorScheme.onPrimary),
        horizontalSpacing(elementSpacing),
        Expanded(
          child: Obx(() {
            final fileName = (value.value ?? "Choose a file").split("\\").last;
            return Text(fileName == "" ? "Choose a file" : fileName, style: Get.theme.textTheme.labelMedium, overflow: TextOverflow.ellipsis,);
          }),
        ),
        horizontalSpacing(elementSpacing),
        FJElevatedButton(
          child: Text("Browse", style: Get.theme.textTheme.labelMedium),
          onTap: () async {
            final result = await fp.FilePicker.platform.pickFiles(type: fileType);
            if(result != null && result.paths.isNotEmpty) {
              setValue(result.paths.first!);
            }
          },
        )
      ],
    );
  }
}

class SelectionSetting extends Setting<int> {
  final List<SelectableItem> options;
  SelectionSetting(String name, String description, bool exposed, int def, this.options) : super(name, description, SettingType.selection, exposed, def);

  @override
  Widget build(BuildContext context) {
    return Obx(() =>ListSelection(
      currentIndex: value.value ?? _defaultValue,
      items: options,
      callback: (newVal, index) {
        setValue(index);
      },
    ));
  }
}