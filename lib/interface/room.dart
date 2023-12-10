class Room implements Comparable {
  String roomId;
  bool seaView;
  double stars;
  String pictureUrl;
  double price;
  int beds;
  int adults;
  List<String>? slideshow;

  Room(
      {required this.roomId,
      required this.seaView,
      required this.beds,
      required this.stars,
      required this.adults,
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
      beds: int.parse(map['beds'].toString()),
      adults: int.parse(map['adults'].toString()),
    );
  }
  factory Room.fromDynamic(dynamic map) {
    return Room(
      roomId: map['room_id'],
      seaView: map['sea_view']??false,
      stars: double.parse(map['stars'].toString()),
      pictureUrl: map['picture_url'],
      slideshow: _getSlideShow(map['slideshow'] ?? []),
      price: double.parse(map['price'].toString()),
      beds: int.parse(map['beds'].toString()),
      adults: int.parse(map['adults'].toString()),
    );
  }

  String get floorText {
    var floor = int.parse(roomId.replaceAll(RegExp(r'[^0-9]'), ''));
    return floor == 1 ? 'First Floor' : floor == 2 ? 'Second Floor' : '${floor}th Floor';
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
        'beds': beds,
        'adults': adults,
      };


  @override
  String toString() {
    return 'Room{roomId: $roomId, seaView: $seaView, stars: $stars, pictureUrl: $pictureUrl, price: $price, beds: $beds, adults: $adults, slideshow: $slideshow}';
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
