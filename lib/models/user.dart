class User {
  String name;
  String description;
  String image;
  String token;

  User({
    this.name,
    this.description,
    this.image,
    this.token,
  });

  User.fromRaw(Map map)
      : this.name = map["name"],
        this.description = map["description"],
        this.image = map["image"],
        this.token = map["token"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (name != null) json["name"] = name;
    if (description != null) json["description"] = description;
    if (image != null) json["image"] = image;
    if (token != null) json["token"] = token;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is User &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              description == other.description &&
              image == other.image &&
              token == other.token;

  @override
  int get hashCode =>
      name.hashCode ^
      description.hashCode ^
      image.hashCode ^
      token.hashCode;

  @override
  String toString() {
    return 'User{name: $name, description: $description,'
        ' image: $image, token: $token}';
  }
}