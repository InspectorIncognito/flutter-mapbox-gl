part of mapbox_gl;


class TextOptions {
  const TextOptions({
    this.description,
    this.bearing,
    this.color,
    this.target,
  });

  final String description;
  final double bearing;
  final String color;
  final LatLng target;

  static const TextOptions defaultOptions = TextOptions();

  TextOptions copyWith(TextOptions changes) {
    if (changes == null) {
      return this;
    }
    return TextOptions(
      description: changes.description ?? description,
      bearing: changes.bearing ?? bearing,
      color: changes.color ?? color,
      target: changes.target ?? target,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('description', description);
    addIfPresent('bearing', bearing);
    addIfPresent('color', color);
    addIfPresent('latitude', target.latitude);
    addIfPresent('longitude', target.longitude);
    return json;
  }
}