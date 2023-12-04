import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/repository/room/room_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RoomLocal extends RoomRepository {
  final SharedPreferences _prefs = SharedPrefController.reference;

  @override
  List<Room> getEmptyRooms({required DateTime start, required DateTime end}) {
    try{
      return _prefs
          .getStringList('rooms')!
          .map((e) => Room.fromDynamic(jsonDecode(e)))
          .toList();
    }catch(e){
      return [];
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
    return _prefs
        .getStringList('rooms')!
        .map(jsonDecode)
        .map(Room.fromDynamic)
        .where((element) => _applyFilters(element,
            adult: adult,
            bed: bed,
            max: max,
            min: min,
            rating1: rating1,
            rating2: rating2,
            rating3: rating3,
            rating4: rating4,
            rating5: rating5))
        .toList();
  }

  _applyFilters(Room room,
      {required int adult,
      required int bed,
      required double max,
      required double min,
      required int rating1,
      required int rating2,
      required int rating3,
      required int rating4,
      required int rating5}) {
    bool a = true;
    if (adult != 0 && room.adults < adult) {
      a = false;
    }
    if (bed != 0 && room.beds < bed) {
      a = false;
    }
    if (room.price > max) {
      a = false;
    }
    if (room.price < min) {
      a = false;
    }
    var rating = room.stars.round();
    if (rating != rating1 &&
        rating != rating2 &&
        rating != rating3 &&
        rating != rating4 &&
        rating != rating5) {
      a = false;
    }
    return a;
  }

  @override
  getMyRooms({required String userId}) {
    Get.snackbar('No Internet Connection', 'try again later');
  }

  @Deprecated("Unimplemented")
  @override
  getNextID(String floor) {
    throw UnimplementedError();
  }

  @override
  Future<void> saveRoom(Room room) async {
    Get.snackbar('No Internet Connection', 'try again later');
  }

  @Deprecated("Unimplemented")
  @override
  Future<String> uploadImage(File file, String roomId) {
    throw UnimplementedError();
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

  saveRoomsToPref(List<Room> rooms) async {
    await _prefs.setStringList(
        'rooms', rooms.map((e) => jsonEncode(e)).toList());
  }


}
