import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomRequestApi {
  final _requestsSupabase = Supabase.instance.client.from('request');
  final _roomSupabase = Supabase.instance.client.from('room');

  addRoomRequest(RoomRequest request) async {
    if (await requestExists(request)) {
      Get.snackbar("You already applied for this room", '');
    } else {
      await _requestsSupabase.insert(request);
      Get.offNamed('/home');
      Get.snackbar("Room Applied", '');
    }
  }

  Future<bool> requestExists(RoomRequest request) async {
    var a = await _requestsSupabase
        .select('*')
        .eq('customer_id', request.customerId)
        .eq('room_id', request.roomId);
    try {
      var temp = RoomRequest.fromDynamic(a[0]);
      if (matchDates(temp.startingDate, request.startingDate, false) &&
          matchDates(temp.endingDate, request.endingDate, true) &&
          (temp.status == STATUS.denied ||
              temp.status == STATUS.pending ||
              temp.status == STATUS.approved)) {
        return true;
      }
    } catch (e) {
      return false;
    }
    return false;
  }

  reserveRoom(String roomId, String customerId, DateTimeRange dates) async {
    return await addRoomRequest(RoomRequest(
        id: 0,
        roomId: roomId,
        customerId: customerId,
        time: DateTime.now(),
        startingDate: dates.start,
        endingDate: dates.end,
        status: STATUS.pending));
  }

  bool matchDates(DateTime first, DateTime second, bool depart) {
    return true;
  }

  _updateStatus(List<int> ids) async {
    await _requestsSupabase
        .update({'status': 'reserved'})
        .in_('id', ids)
        .select();
  }

  Future<List<dynamic>> _getAllRequestsWithRoomId(String roomId) async {
    return await _requestsSupabase.select('*').eq('room_id', roomId);
  }

  Stream<List<Map<String, dynamic>>> getRequestsStream() {
    return _requestsSupabase.stream(primaryKey: ['id']);
  }

  approve(int id, String roomId) async {
    await _requestsSupabase.update({'status': 'approved'}).eq('id', id);
  }

  deny(int id, String roomId) async {
    await _requestsSupabase.update({'status': 'denied'}).eq('id', id);
  }

  autoApprove(String roomId) async {
    List<RoomRequest> requests = (await _getAllRequestsWithRoomId(roomId))
        .map((e) => RoomRequest.fromDynamic(e))
        .toList();
    requests.sort((x, y) => x.time.compareTo(y.time));
    DateTime reservedEnd = requests.first.endingDate;
    List<int> ids = [];
    DateTime reservedStart = requests.first.startingDate;
    for (var value in requests) {
      if (value == requests.first) {
        value.status = STATUS.approved;
        await _requestsSupabase
            .update({'status': 'approved'}).eq('id', value.id);
        await _roomSupabase.update({'reserved': true}).eq('room_id', roomId);
        continue;
      }
      if (!value.startingDate.isAfter(reservedEnd) ||
          !value.endingDate.isBefore(reservedStart)) {
        ids.add(value.id);
      }
    }
    _updateStatus(ids);
  }

}
