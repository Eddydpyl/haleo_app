import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String user;
  String name;
  String description;
  String image;
  final Map<String, dynamic> point; // Contains a geohash and geopoint.
  String topic; // For sending notifications to the attendees.
  bool open; // Whether there are any slots remaining (filter).
  int slots; // How many attendees the host wants for the event.
  int count; // Number of people that have already shown interest.
  List<String> attendees; // Users that are interested in the event.

  Event({
    this.user,
    this.name,
    this.description,
    this.image,
    this.point,
    this.topic,
    this.open,
    this.slots,
    this.count,
    this.attendees,
  });

  Event.fromRaw(Map map)
      : this.user = map["user"],
        this.name = map["name"],
        this.description = map["description"],
        this.image = map["image"],
        this.point = map["point"] != null
            ? Map.from(map["point"]) : null,
        this.topic = map["topic"],
        this.open = map["open"],
        this.slots = map["slots"],
        this.count = map["count"],
        this.attendees = map["attendees"];

  Map<String, dynamic> toJson([bool update = false]) {
    Map<String, dynamic> json = {};
    if (name != null) json["name"] = name;
    if (description != null) json["description"] = description;
    if (image != null) json["image"] = image;
    if (point != null) json["point"] = point;
    if (topic != null) json["topic"] = topic;
    if (open != null) json["open"] = open;
    if (slots != null) json["slots"] = slots;
    if (count != null) json["count"] = count;
    if (attendees != null) json["attendees"] = update
        ? FieldValue.arrayUnion([attendees]) : attendees;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Event &&
              runtimeType == other.runtimeType &&
              user == other.user &&
              name == other.name &&
              description == other.description &&
              image == other.image &&
              point == other.point &&
              topic == other.topic &&
              open == other.open &&
              slots == other.slots &&
              count == other.count &&
              attendees == other.attendees;

  @override
  int get hashCode =>
      user.hashCode ^
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      point.hashCode ^
      topic.hashCode ^
      open.hashCode ^
      slots.hashCode ^
      count.hashCode ^
      attendees.hashCode;

  @override
  String toString() {
    return 'Event{user: $user, name: $name, description: $description,'
        ' image: $image, point: $point, topic: $topic, open: $open,'
        ' slots: $slots, count: $count, attendees: $attendees}';
  }
}