import 'dart:convert';

import 'package:hotel_management/util/date_formatter_util.dart';

class CustomerDetails {
  int id;
  int customerId;
  String firstName;
  String lastName;
  String email;
  DateTime dateOfBirth;
  CustomerDetails(
      {required this.id,
      required this.customerId,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.dateOfBirth});

  factory CustomerDetails.fromJson(String json) {
    final data = jsonDecode(json);
    return CustomerDetails(
      id: data['id'],
      customerId: data['customer_id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      dateOfBirth: DateFormatter.parse(data['date_of_birth']),
    );
  }
  Map<String, dynamic> toJson() => {
    'id' : id,
    'customer_id' : customerId,
    'first_name' : firstName,
    'last_name' : lastName,
    'email' : email,
    'date_of_birth' : DateFormatter.format(dateOfBirth),
  };
}
