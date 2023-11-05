import 'dart:convert';

class Customer {
  int id;
  bool reserving;
  String username;

  Customer({required this.id, required this.reserving, required this.username});

  factory Customer.fromJson(String json) {
    final data = jsonDecode(json);
    return Customer(
      id: data['id'],
      reserving: data['reserving'],
      username: data['username'],
    );
  }

  factory Customer.fromDynamic(dynamic json) {
    final data = jsonDecode(json.toString());
    return Customer(
      id: data['id'],
      reserving: data['reserving'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reserving': reserving,
        'username': username,
      };
}
