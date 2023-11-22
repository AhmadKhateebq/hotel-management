import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomRequestApi extends RoomRequestRepository {
  late final SupabaseQueryBuilder _requestsSupabase;

  RxList<RoomRequest> requests = <RoomRequest>[].obs;

  Future<void> init() async {
    try {
      await Supabase.initialize(
        url: supabaseUrl,
        anonKey: publicAnonKey,
      );
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
    _requestsSupabase = Supabase.instance.client.from('request');
  }

  @override
  addRoomRequest(RoomRequest request) async {
    if (await _requestExists(request)) {
      Get.snackbar("You already applied for this room", '');
    } else {
      await _requestsSupabase.insert(request);
      Get.offNamed('/home');
      Get.snackbar("Room Applied", '');
    }
  }

  Future<bool> _requestExists(RoomRequest request) async {
    var a = await _requestsSupabase
        .select('*')
        .eq('customer_id', request.customerId)
        .eq('room_id', request.roomId);
    try {
      var temp = RoomRequest.fromDynamic(a[0]);
      if (_matchDates(temp.startingDate, request.startingDate, false) &&
          _matchDates(temp.endingDate, request.endingDate, true) &&
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

  @override
  reserveRoom(String roomId, String customerId, DateTimeRange dates) async {
    return await addRoomRequest(RoomRequest(
        id: 0,
        roomId: roomId,
        customerId: customerId,
        time: DateTime.now().toUtc(),
        startingDate: dates.start,
        endingDate: dates.end,
        status: STATUS.pending));
  }


  bool _matchDates(DateTime first, DateTime second, bool depart) {
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


  @override
  approve(int id, String roomId) async {
    await _requestsSupabase.update({'status': 'approved'}).eq('id', id);
  }

  @override
  deny(int id, String roomId) async {
    await _requestsSupabase.update({'status': 'denied'}).eq('id', id);
  }

  @override
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
        continue;
      }
      if (!value.startingDate.isAfter(reservedEnd) ||
          !value.endingDate.isBefore(reservedStart)) {
        ids.add(value.id);
      }
    }
    _updateStatus(ids);
  }

  @override
  Future<List<RoomRequest>> getRoomRequests() async {
    var requests = await _requestsSupabase.select<List<dynamic>>('*');
    return requests.map(RoomRequest.fromDynamic).toList();
  }

  Stream<List<Map<String, dynamic>>> getStream() {
    return _requestsSupabase.stream(primaryKey: ['id']);
  }

  @override
  setUpListener(void Function() func) {
    throw UnimplementedError();
  }
}
