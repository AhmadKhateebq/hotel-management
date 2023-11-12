import 'dart:io';

import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'room_repository.dart';

class RoomApi extends RoomRepository{
  final _supabase = Supabase.instance.client;
  @override
  Future<List<Room>> getAllRooms() async {
    return await _supabase.from('room').select('*');
  }

  @override
  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end}) async {
    List<dynamic> a = await _supabase.rpc('get_rooms', params: {
      "start": DateFormatter.format(start),
      'end_date': DateFormatter.format(end)
    });
    return a.map((e) => Room.fromDynamicMap(e as Map)).toList()..sort();
  }

  @override
  Future<Room> getRoomById(String id) async {
    return await _supabase.from('room').select('*').eq('room_id', id);
  }

  @override
  Stream<List<Map<String, dynamic>>> getRoomsStream() {
    return _supabase.from('room').stream(primaryKey: ['room_id']);
  }

  @override
  Future<bool> roomExists(String id) async {
    List<dynamic> ids =
    await _supabase.from('room').select('room_id').eq('room_id', id);
    if (ids.isEmpty) {
      return false;
    }
    return true;
  }

  @override
  Future<void> saveRoom(Room room) async {
    return await _supabase.from('room').insert(room);
  }

  @override
  Future<String> uploadImage(File file, String roomId) async {
    await _supabase.storage
        .from('room_images')
        .upload('$roomId/thumbnail${p.extension(file.path)}', file);
    final res = _supabase.storage
        .from('room_images')
        .getPublicUrl('$roomId/thumbnail${p.extension(file.path)}');
    return res;
  }
  bool validateData(String roomId){
    RegExp myRegExp = RegExp(r"^[0-9]{1,2}[A-Z]{1,2}$");
    if (myRegExp.hasMatch(roomId)) {
      var match = myRegExp.matchAsPrefix(roomId)!;
      if (roomId.length == match.end) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }
}