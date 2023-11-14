class RoomReview{
  final String roomId;
  final String customerId;
  final double rating;

  RoomReview({required this.roomId, required this.customerId, required this.rating});

  @override
  String toString() {
    return 'RoomReview{roomId: $roomId, customerId: $customerId, rating: $rating}';
  }

  Map<String,dynamic>toJson() =>{'room_id': roomId, 'customer_id': customerId, 'rating': rating};
}