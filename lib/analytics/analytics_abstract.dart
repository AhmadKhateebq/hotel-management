import 'package:hotel_management/interface/room.dart';

abstract class HotelAnalytics {

  logLogInEvent();

  logLogOutEvent();

  logReserveEvent(Room room);

}
