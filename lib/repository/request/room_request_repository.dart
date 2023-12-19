import 'package:flutter/material.dart';
import 'package:hotel_management/interface/request.dart';

abstract class RoomRequestRepository {
  Future<List<RoomRequest>> getRoomRequests();
  Future<List<RoomRequest>> getMyRoomRequests();

  addRoomRequest(RoomRequest request);

  reserveRoom(String roomId, String customerId, DateTimeRange dates);

  approve(int id, String roomId);

  deny(int id, String roomId);

  autoApprove(String roomId);

}
