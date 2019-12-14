import 'package:geoflutterfire/geoflutterfire.dart';

class Event {
  String user;
  String name;
  String description;
  String image;
  GeoFirePoint geoPoint;
  String created;
  bool open;
  int count;

  Event({
    this.user,
    this.name,
    this.description,
    this.image,
    this.geoPoint,
    this.created,
    this.open,
    this.count,
  });
}