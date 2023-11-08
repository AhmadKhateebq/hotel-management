

class Room implements Comparable {
  String roomId;
  bool reserved;
  double stars;
  String pictureUrl;
  double price;
  List<String>? slideshow;

  Room(
      {required this.roomId,
      required this.reserved,
      required this.stars,
      required this.pictureUrl,
      this.slideshow,
      required this.price});

  factory Room.fromDynamicMap(Map<dynamic, dynamic> map) {
    return Room(
      roomId: map['room_id'],
      reserved: map['reserved'],
      stars: double.parse(map['stars'].toString()),
      pictureUrl: map['picture_url'],
      slideshow: _getSlideShow(map['slideshow'] ?? []),
      price: double.parse(map['price'].toString()),
    );
  }

  static List<String> _getSlideShow(List<dynamic> values) {
    return values.map((e) => e.toString()).toList();
  }

  Map<String, dynamic> toJson() => {
        'room_id': roomId,
        'reserved': reserved,
        'stars': stars,
        'picture_url': pictureUrl,
        'price': price,
        'slideshow': slideshow,
      };

  @override
  String toString() {
    return 'Room{roomId: $roomId, reserved: $reserved, stars: $stars, pictureUrl: $pictureUrl, price: $price, slideshow: $slideshow}';
  }

  @override
  int compareTo(other) {
    final aFloor = roomId.replaceAll(RegExp(r'[^0-9]'), '');
    final bFloor = other.roomId.replaceAll(RegExp(r'[^0-9]'), '');
    if (aFloor != bFloor) {
      return aFloor.compareTo(bFloor);
    }
    if (reserved) {
      if (other.reserved) {
        return 0;
      }
      return 2;
    }
    if (other.reserved) {
      if (reserved) {
        return 0;
      }
      return -2;
    }
    return roomId.compareTo(other.roomId);
  }
}
