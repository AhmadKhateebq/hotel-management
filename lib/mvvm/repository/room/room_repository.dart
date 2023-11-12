import 'dart:io';

import '../../model/room.dart';

abstract class RoomRepository{
  Future<List<Room>> getAllRooms();
  Future<Room> getRoomById(String id);
  Stream<List<Map<String, dynamic>>> getRoomsStream();
  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end});
  Future<void> saveRoom(Room room);
  Future<String> uploadImage(File file, String roomId);
  Future<bool> roomExists(String id);
}