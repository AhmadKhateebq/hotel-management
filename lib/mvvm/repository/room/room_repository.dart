import 'dart:io';

import '../../model/room.dart';

abstract class RoomRepository {
  Future<List<Room>> getAllRooms();

  Future<Room> getRoomById(String id);

  Stream<List<Map<String, dynamic>>> getRoomsStream();

  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end});

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
        required int rating5,
      });

  Future<void> saveRoom(Room room);

  Future<String> uploadImage(File file, String roomId);

  Future<bool> roomExists(String id);
}
