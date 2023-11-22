import 'dart:convert';

import 'package:hotel_management/util/util_classes.dart';

class RoomRequest implements Comparable {
  int id;
  String roomId;
  String customerId;
  DateTime time;
  DateTime startingDate;
  DateTime endingDate;
  STATUS status;

  RoomRequest({
    required this.id,
    required this.roomId,
    required this.customerId,
    required this.time,
    required this.startingDate,
    required this.endingDate,
    required this.status,
  });

  factory RoomRequest.fromJson(String json) {
    final data = jsonDecode(json);
    return RoomRequest(
        id: data['id']??0,
        time: DateTime.parse(data['time']),
        startingDate: DateTime.parse(data['starting_date']),
        endingDate: DateTime.parse(data['ending_date']),
        status:StatusUtil.getStatus( data['status']),
        customerId: data['customer_id'],
        roomId: data['room_id']);
  }

  factory RoomRequest.fromDynamic(dynamic data) {
    return RoomRequest(
        id: data['id']??0,
        time: DateTime.parse(data['time']),
        startingDate: DateTime.parse(data['starting_date']),
        endingDate: DateTime.parse(data['ending_date']),
        status: StatusUtil.getStatus(data['status']),
        customerId: data['customer_id'],
        roomId: data['room_id']);
  }

  Map<String, dynamic> toJson() => {
        'time': (time).toString(),
        'room_id': roomId,
        'customer_id': customerId,
        'starting_date': (startingDate).toString(),
        'ending_date': (endingDate).toString(),
        'status': StatusUtil.getStatusString(status)
      };


  @override
  String toString() {
    return 'RoomRequest{id: $id, roomId: $roomId, customerId: $customerId, time: $time, startingDate: $startingDate, endingDate: $endingDate, status: $status}';
  }

  factory RoomRequest.fromDynamicMap(Map<String, dynamic> data) => RoomRequest(
      id: data['id']??0,
      time: DateTime.parse(data['time']),
      startingDate: DateTime.parse(data['starting_date']),
      endingDate: DateTime.parse(data['ending_date']),
      status: StatusUtil.getStatus(data['status']),
      customerId: data['customer_id'],
      roomId: data['room_id']);

  @override
  int compareTo(other) {
    return other.time.compareTo((time));
  }


}
