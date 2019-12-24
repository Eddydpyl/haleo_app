import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String user;
  String name;
  String description;
  String image;
  final Map<String, dynamic> point; // Contains a geohash and geopoint.
  bool open; // Whether there are any slots remaining (filter).
  int slots; // How many attendees the host wants for the event.
  int count; // Number of people that have already shown interest.
  List<String> attendees; // Users that are interested in the event.
  String created; // The date at which the event was created.
  String lang; // Language of the event (for notifications).

  Event({
    this.user,
    this.name,
    this.description,
    this.image,
    this.point,
    this.open,
    this.slots,
    this.count,
    this.attendees,
    this.created,
    this.lang,
  });

  Event.fromRaw(Map map)
      : this.user = map["user"],
        this.name = map["name"],
        this.description = map["description"],
        this.image = map["image"],
        this.point = map["point"] != null
            ? Map.from(map["point"]) : null,
        this.open = map["open"],
        this.slots = map["slots"],
        this.count = map["count"],
        this.attendees = map["attendees"] != null
            ? List<String>.from(map["attendees"]) : [],
        this.created = map["created"],
        this.lang = map["lang"];

  Map<String, dynamic> toJson([bool update = false]) {
    Map<String, dynamic> json = {};
    if (user != null) json["user"] = user;
    if (name != null) json["name"] = name;
    if (description != null) json["description"] = description;
    if (image != null) json["image"] = image;
    if (point != null) json["point"] = point;
    if (open != null) json["open"] = open;
    if (slots != null) json["slots"] = slots;
    if (count != null) json["count"] = count;
    if (attendees != null) json["attendees"] = update
        ? FieldValue.arrayUnion(attendees) : attendees;
    if (created != null) json["created"] = created;
    if (lang != null) json["lang"] = lang;
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
              open == other.open &&
              slots == other.slots &&
              count == other.count &&
              attendees == other.attendees &&
              created == other.created &&
              lang == other.lang;

  @override
  int get hashCode =>
      user.hashCode ^
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      point.hashCode ^
      open.hashCode ^
      slots.hashCode ^
      count.hashCode ^
      attendees.hashCode ^
      created.hashCode ^
      lang.hashCode;

  @override
  String toString() {
    return 'Event{user: $user, name: $name, description: $description,'
        ' image: $image, point: $point, open: $open, slots: $slots,'
        ' count: $count, attendees: $attendees,'
        ' created: $created, lang: $lang}';
  }
}