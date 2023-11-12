

class Room implements Comparable {
  String roomId;
  bool seaView;
  double stars;
  String pictureUrl;
  double price;
  List<String>? slideshow;

  Room(
      {required this.roomId,
      required this.seaView,
      required this.stars,
      required this.pictureUrl,
      this.slideshow,
      required this.price});

  factory Room.fromDynamicMap(Map<dynamic, dynamic> map) {
    return Room(
      roomId: map['room_id'],
      seaView: map['sea_view'],
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
        'sea_view': seaView,
        'stars': stars,
        'picture_url': pictureUrl,
        'price': price,
        'slideshow': slideshow,
      };

  @override
  String toString() {
    return 'Room{roomId: $roomId, sea view: $seaView, stars: $stars, pictureUrl: $pictureUrl, price: $price, slideshow: $slideshow}';
  }

  @override
  int compareTo(other) {
    final aFloor = int.parse(roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    final bFloor = int.parse(other.roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    if (aFloor != bFloor) {
      return aFloor.compareTo(bFloor);
    }
    return roomId.compareTo(other.roomId);
  }
}
