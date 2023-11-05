import 'dart:convert';

import 'package:hotel_management/util/date_formatter_util.dart';


enum RoomStatus { pending, approved, denied, reserved }

class RoomRequest {
  int id;
  DateTime time;
  DateTime startingDate;
  DateTime endingDate;
  RoomStatus status;

  RoomRequest({
    required this.id,
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
        status: data['status']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'time': DateFormatter.formatWithTime(time),
        'starting_date': DateFormatter.formatWithTime(startingDate),
        'ending_date': DateFormatter.formatWithTime(endingDate),
        'status': status
      };
}
