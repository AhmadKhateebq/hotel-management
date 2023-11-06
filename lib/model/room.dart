import 'dart:convert';

class Room implements Comparable {
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

  @override
  int compareTo(other) {
    final aFloor = roomId.replaceAll(RegExp(r'[^0-9]'), '');
    final bFloor = other.roomId.replaceAll(RegExp(r'[^0-9]'), '');
    if (aFloor != bFloor) {
      return aFloor.compareTo(bFloor);
    }
    if (reserved) {
      if (other.reserved) {
        return 0;
      }
      return 2;
    }
    if (other.reserved) {
      if (reserved) {
        return 0;
      }
      return -2;
    }
    return roomId.compareTo(other.roomId);
  }
}
