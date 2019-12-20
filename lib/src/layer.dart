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

  void addProperty(Property property) {
    properties.add(property.data);
  }

  void addFilter(Filter filter) {
    filters.add(filter.data);
  }

}

class Property {
  final String _data;
  Property._(this._data);

  factory Property.iconSize(double size) {return Property._("iconSize;$size");}
  factory Property.iconAllowOverlap(bool allowOverlap) {return Property._("iconAllowOverlap;$allowOverlap");}
  factory Property.iconOffset(int xOffset, int yOffset) {return Property._("iconOffset;$xOffset;$yOffset");}

  String get data => _data;
}

class Filter {
  final String _data;
  Filter._(this._data);

  factory Filter.equal(String property, bool selected) {return Filter._("equal;$property;$selected");}

  String get data => _data;
}
