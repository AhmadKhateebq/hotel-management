import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/model/room_review.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyRoomsFacade {
  final _supabase = Supabase.instance.client;
  final RoomApi _roomApi = RoomApi();
  final String _userId = Get.find<SupabaseAuthController>().loginUser.user!.id;

  Future<List<Room>> getRooms() async {
    try {
      return await _roomApi.getMyRooms(userId: _userId);
    }  catch(e){
      return [];
    }
  }

  submitReview(String roomId, double rating) async {
    RoomReview review =
        RoomReview(roomId: roomId, customerId: _userId, rating: rating);
    if (await reviewExist(review.roomId)) {
      await _supabase.from('review').insert(review.toJson());
      Get.snackbar('Review Sent', 'your review has been sent');
    } else {
      await _supabase
          .from('review')
          .update({'rating': review.rating})
          .eq('customer_id', _userId)
          .eq("room_id", review.roomId);
      Get.snackbar('Review Sent', 'your review has been Updated');
    }
  }

  Future<double> getAvgReview(String roomId) async {
    double avg = 0;
    var ratings = await _supabase
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

  reviewExist(String roomId) async {
    var res = await _supabase
        .from('review')
        .select<List<Map<String, dynamic>>>('rating')
        .eq('customer_id', _userId)
        .eq('room_id', roomId);
    return res.isEmpty;
  }
}