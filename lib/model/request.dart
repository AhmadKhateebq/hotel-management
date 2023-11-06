import 'dart:convert';

import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';

class RoomRequest {
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
        id: data['id'],
        time: DateTime.parse(data['time']),
        startingDate: DateFormatter.parseWithTime(data['starting_date']),
        endingDate: DateFormatter.parseWithTime(data['ending_date']),
        status: data['status'],
        customerId: data['customer_id'],
        roomId: data['room_id']);
  }

  factory RoomRequest.fromDynamic(dynamic data) {
    return RoomRequest(
        id: data['id'],
        time: DateTime.parse(data['time']),
        startingDate: DateTime.parse(data['starting_date']),
        endingDate: DateTime.parse(data['ending_date']),
        status: getStatus(data['status']),
        customerId: data['customer_id'],
        roomId: data['room_id']);
  }

  Map<String, dynamic> toJson() => {
        'time': DateFormatter.formatWithTime(time),
        'room_id': roomId,
        'customer_id': customerId,
        'starting_date': DateFormatter.formatWithTime(startingDate),
        'ending_date': DateFormatter.formatWithTime(endingDate),
        'status': getStatusString(status)
      };


  @override
  String toString() {
    return 'RoomRequest{id: $id, roomId: $roomId, customerId: $customerId, time: $time, startingDate: $startingDate, endingDate: $endingDate, status: $status}';
  }

  factory RoomRequest.fromDynamicMap(Map<String, dynamic> data) => RoomRequest(
      id: data['id'],
      time: DateTime.parse(data['time']),
      startingDate: DateTime.parse(data['starting_date']),
      endingDate: DateTime.parse(data['ending_date']),
      status: getStatus(data['status']),
      customerId: data['customer_id'],
      roomId: data['room_id']);

  static STATUS getStatus(String status) => status == 'reserved'
      ? STATUS.reserved
      : status == 'approved'
          ? STATUS.approved
          : status == 'denied'
              ? STATUS.denied
              : STATUS.pending;

  static String getStatusString(STATUS status) => status == STATUS.reserved
      ? 'reserved'
      : status == STATUS.approved
          ? 'approved'
          : status == STATUS.denied
              ? 'denied'
              : 'pending';
}
