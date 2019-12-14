class User {
  String name;
  String description;
  String image;

  User({
    this.name,
    this.description,
    this.image,
  });

  User.fromRaw(Map map)
      : this.name = map["name"],
        this.description = map["description"],
        this.image = map["image"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (name != null) json["name"] = name;
    if (description != null) json["description"] = description;
    if (image != null) json["image"] = image;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              description == other.description &&
              image == other.image;

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      image.hashCode;

  @override
  String toString() {
    return 'AppUser{name: $name, description: $description, image: $image}';
  }
}