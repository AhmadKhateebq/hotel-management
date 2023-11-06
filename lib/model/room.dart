import 'dart:convert';

class Room {
  String roomId;
  bool reserved;

  Room({required this.roomId, required this.reserved});

  factory Room.fromJson(String json) {
    final data = jsonDecode(json);
    return Room(
      roomId: data['room_id'],
      reserved: data['reserved'],
    );
  }

  factory Room.fromDynamic(dynamic json) {
    final data = jsonDecode(json.toString());
    return Room(
      roomId: data['room_id'],
      reserved: data['reserved'],
    );
  }

  factory Room.fromDynamicMap(Map<dynamic, dynamic> map) {
    return Room(
      roomId: map['room_id'],
      reserved: map['reserved'],
    );
  }

  Map<String, dynamic> toJson() => {'room_id': roomId, 'reserved': reserved};
}
