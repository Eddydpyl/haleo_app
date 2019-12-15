class Perimeter {
  double lat;
  double lng;
  double radius;

  Perimeter({
    this.lat,
    this.lng,
    this.radius,
  });

  Perimeter.fromRaw(Map map)
      : this.lat = map["lat"],
        this.lng = map["lng"],
        this.radius = map["radius"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (lat != null) json["lat"] = lat;
    if (lng != null) json["lng"] = lng;
    if (radius != null) json["radius"] = radius;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Perimeter &&
              runtimeType == other.runtimeType &&
              lat == other.lat &&
              lng == other.lng &&
              radius == other.radius;

  @override
  int get hashCode =>
      lat.hashCode ^
      lng.hashCode ^
      radius.hashCode;

  @override
  String toString() {
    return 'Perimeter{lat: $lat, lng: $lng, radius: $radius}';
  }
}