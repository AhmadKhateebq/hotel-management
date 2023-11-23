import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginUser {
  late CustomerDetails currentCustomerDetails;
  User? user;
  String? _profileImageUrl;
  String? _fullName;
  ROLE? _role;

  set profileImageUrl(String value) {
    _profileImageUrl = value;
  }

  LoginUser();

  LoginUser.initialized(
      {required this.currentCustomerDetails,
      required this.user,
      required String imageUrl,
      required String fullName,
      required ROLE role})
      : _profileImageUrl = imageUrl,
        _fullName = fullName,
        _role = role;

  String get profileImageUrl => _profileImageUrl ?? "";

  String get fullName => _fullName ?? "John Doe";

  ROLE get role => _role ?? ROLE.customer;

  logout() async {
    user = null;
    _fullName = null;
    _profileImageUrl = null;
    _role = null;
  }

  set fullName(String value) {
    _fullName = value;
  }

  set role(ROLE value) {
    _role = value;
  }


}
