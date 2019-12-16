class MessageType {
  static final int text = 0;
  static final int image = 1;
}

class Message {
  String event;
  String user;
  String date;
  String data;
  int type;

  Message({
    this.event,
    this.user,
    this.date,
    this.data,
    this.type,
  });

  Message.fromRaw(Map map)
      : this.event = map["event"],
        this.user = map["user"],
        this.date = map["date"],
        this.data = map["data"],
        this.type = map["type"];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (event != null) json["event"] = event;
    if (user != null) json["user"] = user;
    if (date != null) json["date"] = date;
    if (data != null) json["data"] = data;
    if (type != null) json["type"] = type;
    return json;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Message &&
              runtimeType == other.runtimeType &&
              event == other.event &&
              user == other.user &&
              date == other.date &&
              data == other.data &&
              type == other.type;

  @override
  int get hashCode =>
      event.hashCode ^
      user.hashCode ^
      date.hashCode ^
      data.hashCode ^
      type.hashCode;

  @override
  String toString() {
    return 'Message{event: $event, user: $user,'
        ' date: $date, data: $data, type: $type}';
  }
}