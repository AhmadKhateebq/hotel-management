import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomRequestController {
  final _requestsSupabase = Supabase.instance.client.from('request');
  final _roomSupabase = Supabase.instance.client.from('room');

  addRoomRequest(RoomRequest request) async {
    await _requestsSupabase.insert(request);
  }

  _updateStatus(List<int> ids) async {
    var a = await _requestsSupabase
        .update({'status': 'reserved'})
        .in_('id', ids)
        .select();
    print(a.toString());
  }

  Future<List<dynamic>> _getAllRequestsWithRoomId(String roomId) async {
    return await _requestsSupabase.select('*').eq('room_id', roomId);
  }

  Stream<List<Map<String, dynamic>>> getRequestsStream() {
    return _requestsSupabase.stream(primaryKey: ['id']);
  }

  approve(int id, String roomId) async {
    await _requestsSupabase.update({'status': 'approved'}).eq('id', id);
    await _roomSupabase.update({'reserved': true}).eq('room_id', roomId);
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
