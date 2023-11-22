import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/request.dart';

abstract class RoomRequestRepository {
  Future<List<RoomRequest>> getRoomRequests();

  addRoomRequest(RoomRequest request);

  reserveRoom(String roomId, String customerId, DateTimeRange dates);

  approve(int id, String roomId);

  deny(int id, String roomId);

  autoApprove(String roomId);

  setUpListener(void Function() func);
}
