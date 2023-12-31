import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/analytics/analytics_service.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/repository/request/room_request_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomRequestApi extends RoomRequestRepository {
  final _supabase = Get.find<SupabaseController>().client;

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
  }

  @override
  addRoomRequest(RoomRequest request) async {
    if (await _requestExists(request)) {
      Get.snackbar("You already applied for this room", '');
    } else {
      await _supabase.from('request').insert(request.toJsonNoId());
      await logRoomPurchase(request.roomId);
      Navigator.pushReplacementNamed(Get.context!, '/home');
      Get.snackbar("Room Applied", '');
    }
  }

  Future<bool> _requestExists(RoomRequest request) async {
    var a = await _supabase
        .from('request')
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
    await _supabase
        .from('request')
        .update({'status': 'reserved'})
        .in_('id', ids)
        .select();
  }

  Future<List<dynamic>> _getAllRequestsWithRoomId(String roomId) async {
    return await _supabase.from('request').select('*').eq('room_id', roomId);
  }

  @override
  approve(int id, String roomId) async {
    await _supabase.from('request').update({'status': 'approved'}).eq('id', id);
    await logRoomPurchase(roomId);
  }

  logRoomPurchase(String roomId) async {
    var room =
        await _supabase.from('room').select('*').eq('room_id', roomId).single();
    await Get.find<AnalyticsService>().logReserve(Room.fromDynamicMap(room));
  }

  @override
  deny(int id, String roomId) async {
    await _supabase.from('request').update({'status': 'denied'}).eq('id', id);
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
        await _supabase
            .from('request')
            .update({'status': 'approved'}).eq('id', value.id);
        continue;
      }
      if (!value.startingDate.isAfter(reservedEnd) ||
          !value.endingDate.isBefore(reservedStart)) {
        ids.add(value.id!);
      }
    }
    _updateStatus(ids);
  }

  @override
  Future<List<RoomRequest>> getRoomRequests() async {
    var requests = await _supabase.from('request').select<List<dynamic>>('*');
    return requests.map(RoomRequest.fromDynamic).toList();
  }

  Stream<List<Map<String, dynamic>>> getStream() {
    return _supabase.from('request').stream(primaryKey: ['id']);
  }

  Stream<List<Map<String, dynamic>>> getMyStream() {
    final customerId = Get.find<UserModel>().customerId;
    return _supabase
        .from('request')
        .stream(primaryKey: ['id']).eq('customer_id', customerId);
  }

  @override
  Future<List<RoomRequest>> getMyRoomRequests() async {
    String userId = Get.find<UserModel>().customerId;
    var res = await _supabase.rpc('get_my_requests',
        params: {'user_id': userId}).select<List<Map<String, dynamic>>>('*');
    return res.map(RoomRequest.fromDynamicMap).toList();
  }
}
