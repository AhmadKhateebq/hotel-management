import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:path/path.dart' as p;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'room_repository.dart';

class RoomApi extends RoomRepository {
  late final SupabaseClient _supabase;

  init() async {
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
    _supabase = Supabase.instance.client;
  }

  Future<List<Room>> _getAllRooms() async {
    List<Room> rooms =
        (await _supabase.from('room').select<List<Map<String, dynamic>>>('*'))
            .map((e) => Room.fromDynamicMap(e))
            .toList();
    return rooms;
  }

  @override
  Future<String> getNextID(String floor) async {
    var localFloor = floor.replaceAll(RegExp(r'[^1-9]'), '');
    String roomID = ((await _getAllRooms())
            .where((element) =>
                element.roomId.replaceAll(RegExp(r'[^1-9]'), '') == localFloor)
            .map((e) => e.roomId.replaceAll(RegExp(r'[^A-Z]'), ''))
            .toList()
          ..sort())
        .last;
    return (String.fromCharCode(roomID.codeUnitAt(0) + 1));
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
  Future<List<Room>> getMyRooms({required String userId}) async {
    List<dynamic> a = await _supabase.rpc('get_my_rooms', params: {
      "now": DateFormatter.format(DateTime.now()),
      'user_id': userId
    });
    return a.map((e) => Room.fromDynamicMap(e as Map)).toList()..sort();
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

  @override
  bool validateData(String floor) {
    RegExp myRegExp = RegExp(r"^[0-9]{1}$");
    if (myRegExp.hasMatch(floor)) {
      var match = myRegExp.matchAsPrefix(floor)!;
      if (floor.length == match.end) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  @override
  Future<List<Room>> getEmptyRoomsFiltered(
      {required DateTime start,
      required DateTime end,
      required int adult,
      required int bed,
      required double max,
      required double min,
      required int rating1,
      required int rating2,
      required int rating3,
      required int rating4,
      required int rating5}) async {
    List<dynamic> a = await _supabase.rpc('get_rooms', params: {
      "start": DateFormatter.format(start),
      'end_date': DateFormatter.format(end),
      'adult': adult,
      'bed': bed,
      'max': max,
      'min': min,
      'rating1': rating1,
      'rating2': rating2,
      'rating3': rating3,
      'rating4': rating4,
      'rating5': rating5,
    });

    return a.map((e) => Room.fromDynamicMap(e as Map)).toList()..sort();
  }
}
