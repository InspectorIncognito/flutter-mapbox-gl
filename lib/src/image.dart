
part of mapbox_gl;

class ImageBuilder {
  ImageBuilder(this.id, this.type);

  final String id;
  final String type;

  List<String> _properties = [];
}

class StopImageBuilder extends ImageBuilder {
  StopImageBuilder() : super("busstop-image", "busstop-image");
}

class BusImageBuilder extends ImageBuilder {
  BusImageBuilder(
    String color,
    bool orientedLeft,
  ) : super("bus-$color-$orientedLeft", "bus") {
    _properties.add("color:$color");
    _properties.add("orientedLeft:$orientedLeft");
  }
}