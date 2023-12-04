import 'dart:convert';

import 'package:hotel_management/controller/shared_pref_controller.dart';

const tag = 'user_details';

class UserModel {
  final _pref = SharedPrefController.reference;

  late String profileImageUrl;
  late String firstName;
  late String lastName;
  late String role;
  late String customerId;

  getDetails() async {
    _UserDetails details = _UserDetails.fromJson(_pref.getString(tag)!);
    profileImageUrl = details.profileImageUrl;
    firstName = details.firstName;
    lastName = details.lastName;
    role = details.role;
    customerId = details.customerId;
  }

  saveDetails({required String profileImageUrl,
    required String firstName,
    required String lastName,
    required String customerId,
    required String role}) async {
    await _pref.setString(
        tag,
        _UserDetails.toJson(_UserDetails(
            profileImageUrl: profileImageUrl,
            firstName: firstName,
            lastName: lastName,
            customerId: customerId,
            role: role)));
    this.profileImageUrl = profileImageUrl;
    this.firstName = firstName;
    this.lastName = lastName;
    this.customerId = customerId;
    this.role = role;

  }

  void remove() {
    _pref.remove(tag);
    _pref.remove('token');
  }
}

class _UserDetails {
  final String profileImageUrl;
  final String firstName;
  final String lastName;
  final String customerId;
  final String role;

  _UserDetails({required this.profileImageUrl,
    required this.firstName,
    required this.lastName,
    required this.customerId,
    required this.role});

  static toJson(_UserDetails details) => jsonEncode(details.toMap());

  factory _UserDetails.fromJson(String json) {
    var data = jsonDecode(json);
    return _UserDetails(
        profileImageUrl: data['profile_image_url'],
        firstName: data['first_name'],
        customerId: data['customer_id'],
        lastName: data['last_name'],
        role: data['role']);
  }

  Map<String, dynamic> toMap() =>
      {
        'profile_image_url': profileImageUrl,
        'first_name': firstName,
        'last_name': lastName,
        'customer_id': customerId,
        'role': role,
      };
}
