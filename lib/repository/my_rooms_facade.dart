import 'package:get/get.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/interface/room_review.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/repository/room/room_repository.dart';

class MyRoomsFacade {
  final _supabase = Get.find<SupabaseController>().client;
  final RoomRepository _roomApi = Get.find();
  final String _userId = Get.find<UserModel>().customerId;

  Future<List<Room>> getRooms() async {
    try {
      return await _roomApi.getMyRooms(userId: _userId);
    } catch (e) {
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

  reviewExist(String roomId) async {
    var res = await _supabase
        .from('review')
        .select<List<Map<String, dynamic>>>('rating')
        .eq('customer_id', _userId)
        .eq('room_id', roomId);
    return res.isEmpty;
  }
}
