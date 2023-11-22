import 'dart:convert';
import 'dart:io';

import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomLocal extends RoomRepository {
  final SharedPreferences _prefs = SharedPrefController.reference;

  @override
  Future<List<Room>> getAllRooms() async {
    return _prefs
        .getStringList('rooms')!
        .map((e) => Room.fromDynamic(jsonDecode(e)))
        .toList();
  }

  @override
  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end}) async {
    return _prefs
        .getStringList('rooms')!
        .map((e) => Room.fromDynamic(jsonDecode(e)))
        .toList();
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
    return _prefs
        .getStringList('rooms')!
        .map((e) => Room.fromDynamic(jsonDecode(e)))
        .toList();
  }

  @override
  getMyRooms({required String userId}) {
    // TODO: implement getMyRooms
    throw UnimplementedError();
  }

  @override
  getNextID(String floor) {
    // TODO: implement getNextID
    throw UnimplementedError();
  }

  @override
  Future<Room> getRoomById(String id) async {
    return _prefs
        .getStringList('rooms')!
        .map((e) => Room.fromDynamic(jsonDecode(e)))
        .where((element) => element.roomId == id)
        .first;
  }

  @override
  Stream<List<Map<String, dynamic>>> getRoomsStream() async* {
    List<Map<String, dynamic>> rooms = _prefs
        .getStringList('rooms')!
        .map((e) => Room.fromDynamic(jsonDecode(e)))
        .map((e) => e.toJson())
        .toList();
    yield rooms;
  }

  @override
  Future<bool> roomExists(String id) {
    // TODO: implement roomExists
    throw UnimplementedError();
  }

  @override
  Future<void> saveRoom(Room room) {
    // TODO: implement saveRoom
    throw UnimplementedError();
  }

  @override
  Future<String> uploadImage(File file, String roomId) {
    // TODO: implement uploadImage
    throw UnimplementedError();
  }

  @override
  validateData(String floor) {
    // TODO: implement validateData
    throw UnimplementedError();
  }

  saveRoomsToPref(List<Room> rooms) async {
    await _prefs.setStringList(
        'rooms', rooms.map((e) => jsonEncode(e)).toList());
  }
}
