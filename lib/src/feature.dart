part of mapbox_gl;

class Feature {
  Feature(this._id, this._latitude, this._longitude, String image) {
    addStringProperty("image", image);
  }

  Feature.private(this._id, this._latitude, this._longitude);

  final String _id;
  final double _latitude;
  final double _longitude;

  Map<String, dynamic> properties = {};

  String get id => _id;

  Feature _addProperty(String key, dynamic property) {
    properties[key] = property;
    return this;
  }

  Feature addStringProperty(String key, String value) {
    _addProperty(key, value);
    return this;
  }

  Feature addBooleanProperty(String key, bool value) {
    _addProperty(key, value);
    return this;
  }

  Feature addNumberProperty(String key, double value) {
    _addProperty(key, value);
    return this;
  }

  Map<String, dynamic> toJson() =>
      {
        'id': _id,
        'latitude': _latitude,
        'longitude': _longitude,
        'properties': properties,
      };

  factory Feature.fromJSON(String jsonData) {
    Map<String, dynamic> json = jsonDecode(jsonData);

    Feature feature = Feature.private(json["id"], json["geometry"]["coordinates"][1], json["geometry"]["coordinates"][0]);
    feature.properties = json["properties"];

    return feature;
  }
}
