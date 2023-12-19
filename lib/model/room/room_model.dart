import 'dart:io';

import 'package:get/get.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/repository/room/room_repository.dart';
import 'package:hotel_management/repository/room_repository_impl.dart';
import 'package:hotel_management/util/const.dart';
import 'package:image_picker/image_picker.dart';

class RoomModel extends GetxController{
  List<Room> rooms = [];
  final RoomRepositoryImpl impl = Get.find<RoomRepository>() as RoomRepositoryImpl;
  Future<void> getRoomsBetweenDates(
    DateTime startDate,
    DateTime endDate,
  ) async {
    rooms = await impl.getEmptyRooms(
      start: startDate,
      end: endDate,
    );
  }

  Future<void> getEmptyRoomsFiltered(
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
      required bool seaView}) async {
    rooms = (await impl.getEmptyRoomsFiltered(
            start: start,
            end: end,
            adult: adult,
            bed: bed,
            max: max,
            min: min,
            rating1: rating1,
            rating2: rating2,
            rating3: rating3,
            rating4: rating4,
            rating5: rating5))
        .where((element) {
      if (seaView) {
        return element.seaView;
      } else {
        return true;
      }
    }).toList();
  }

  getRooms() {
    return impl.getRoomsFromCache();
  }

  Future<bool> validateData(String floor) async {
    return  await impl.validateData(floor);
  }

  getNextID(String floor) {
    return impl.getNextID(floor);
  }

  saveRoom(String floor, double rating, image, double price, int beds,
      int size) async {
    String id = await getNextID(floor);
    String imageUrl = await uploadImage(id, image);
    id = '$floor$id';
    Room room = Room(
        roomId: id,
        seaView: true,
        stars: rating,
        pictureUrl: imageUrl,
        price: price,
        slideshow: [noImage, noImage],
        beds: beds,
        adults: size);
    rooms.add(room);
    await impl.saveRoom(room);
  }

  Future<String> uploadImage(String roomId, XFile? image) async {
    return image != null
        ? await impl.uploadImage(File(image.path), roomId)
        : noImage;
  }

  Future<Room> getRoom(String id) async {
    if(rooms.isEmpty){
      rooms = impl.getRoomsFromCache();
    }
    if(rooms.isEmpty){
      rooms = await impl.getRooms();
    }
    return rooms.where((element) => element.roomId == id).first;
  }
}
