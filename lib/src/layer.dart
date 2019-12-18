part of mapbox_gl;

class SymbolLayer {
  SymbolLayer(this._id, this._source);

  final String _id;
  final String _source;

  List<String> properties = [];
  List<String> filters = [];
  double minZoom = 0;
  double maxZoom = 20;

  String get id => _id;
  String get source => _source;

  void addProperty(String property) {
    properties.add(property);
  }

  void addFilter(String filter) {
    filters.add(filter);
  }

}

class PropertyFactory {
  static String iconSize(double size) {
    return "iconSize;$size";
  }

  static String iconAllowOverlap(bool allowOverlap) {
    return "iconAllowOverlap;$allowOverlap";
  }

  static String iconOffset(int xOffset, int yOffset) {
    return "iconOffset;$xOffset;$yOffset";
  }
}

class FilterFactory {
  static String equal(String property, bool selected) {
    return "equal;$property;$selected";
  }
}
