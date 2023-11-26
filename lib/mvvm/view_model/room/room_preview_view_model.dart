import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/connectivity_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoomPreviewViewModel {
  final Room _room;
  RxDouble avg = RxDouble(0);

  RoomPreviewViewModel({
    required Room room,
  }) : _room = room;
  final RoomRequestRepository requestApi= Get.find();

  final CustomerApi customerApi= Get.find();

  get room => _room;

  get roomId => _room.roomId;

  get stars => _room.stars;

  get price => _room.price;

  String get pictureUrl => _room.pictureUrl;

  get slideshow => _room.slideshow ?? [];

  get beds => _room.beds;

  get adults => _room.adults;

  Future<void> reserveRoom() async {
    DateTimeRange dates = await _dateRangePicker() ??
        DateTimeRange(
            start: DateTime.now(),
            end: DateTime.now().add(const Duration(days: 1)));
    var customerId = SharedPrefController.reference.getString('user_id')!;
    requestApi.reserveRoom(roomId, customerId, dates);


  }

  _dateRangePicker() async {
    return await showDateRangePicker(
        firstDate: DateTime.now(),
        lastDate: DateTime.now().add(const Duration(days: 1461)),
        context: Get.context!);
  }

  getAvg() async {
    avg.value = await getAvgReview(_room.roomId);
  }
  Future<double> getAvgReview(String roomId) async {
    double avg = 0;
    if(!Get.find<ConnectivityController>().connected.value){
      return avg;
    }
    var ratings = await Supabase.instance.client
        .from('review')
        .select<List>('rating')
        .eq('room_id', roomId);
    void addAvg(dynamic value) {
      avg += double.parse(value['rating'].toString());
    }

    if (ratings.isNotEmpty) {
      ratings.forEach(addAvg);
      avg /= ratings.length;
    }
    return avg;
  }
}
