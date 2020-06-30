part of mapbox_gl_platform_interface;

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

  void addProperty(LayerProperty property) {
    properties.add(property.data);
  }

  void addFilter(Filter filter) {
    filters.add(filter.data);
  }

}

class LayerProperty {
  final String _data;
  LayerProperty._(this._data);

  factory LayerProperty.iconSize(double size) {return LayerProperty._("iconSize;$size");}
  factory LayerProperty.iconImage(String image) {return LayerProperty._("iconImage;$image");}
  factory LayerProperty.iconImageExpression(String image) {return LayerProperty._("iconImageExpression;$image");}
  factory LayerProperty.iconAllowOverlap(bool allowOverlap) {return LayerProperty._("iconAllowOverlap;$allowOverlap");}
  factory LayerProperty.iconOffset(int xOffset, int yOffset) {return LayerProperty._("iconOffset;$xOffset;$yOffset");}

  String get data => _data;
}

class Filter {
  final String _data;
  Filter._(this._data);

  factory Filter.equal(String property, bool selected) {return Filter._("equal;$property;$selected");}

  String get data => _data;
}