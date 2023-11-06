import 'dart:convert';

import 'package:hotel_management/util/date_formatter_util.dart';

class CustomerDetails {

  String customerId;
  String firstName;
  String lastName;
  String email;
  String? pictureUrl;
  DateTime dateOfBirth;

  CustomerDetails({
    required this.customerId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.pictureUrl,
    required this.dateOfBirth});

  factory CustomerDetails.fromJson(String json) {
    final data = jsonDecode(json);
    return CustomerDetails(
      customerId: data['customer_id'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      email: data['email'],
      pictureUrl: data['picture_url'],
      dateOfBirth: DateFormatter.parse(data['date_of_birth']),
    );
  }

  Map<String, dynamic> toJson() =>
      {
        'customer_id': customerId,
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'picture_url': pictureUrl,
        'date_of_birth': DateFormatter.format(dateOfBirth),
      };

  factory CustomerDetails.fromDynamicMap(Map<dynamic, dynamic> map) {
    return CustomerDetails(customerId: map['customer_id'],
        firstName: map['first_name'],
        lastName: map['last_name'],
        email: map['email'],
        pictureUrl: map['picture_url'],
        dateOfBirth: DateTime.parse(map['date_of_birth']));
  }

  @override
  String toString() {
    return 'CustomerDetails{ customerId: $customerId, firstName: $firstName, lastName: $lastName, email: $email, dateOfBirth: $dateOfBirth}';
  }
}
