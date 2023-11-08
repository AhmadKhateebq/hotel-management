import 'dart:convert';

import 'package:hotel_management/util/util_classes.dart';


class Customer {
  String id;
  bool reserving;
  ROLE role;
  String fullName;

  Customer(
      {required this.id,
      required this.reserving,
      required this.fullName,
      required this.role});

  factory Customer.fromJson(String json) {
    final data = jsonDecode(json);
    return Customer(
      id: data['id'],
      reserving: data['reserving'],
      fullName: data['full_name'],
      role: data['role'],
    );
  }

  factory Customer.fromDynamic(dynamic json) {
    final data = jsonDecode(json.toString());
    return Customer(
      id: data['id'],
      reserving: data['reserving'],
      fullName: data['full_name'],
      role: data['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'reserving': reserving,
        'full_name': fullName,
        'role': Role.roleToString(role),
      };

}
