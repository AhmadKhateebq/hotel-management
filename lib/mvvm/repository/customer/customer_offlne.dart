import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/view/login_screen.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerLocal extends CustomerRepository {
  final SharedPreferences _prefs = SharedPrefController.reference;

  final SupabaseAuthController _auth = Get.find();

  @override
  getCustomerDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    try{
      String firstName = _prefs.getString('first_name')!;
      String lastName = _prefs.getString('last_name')!;
      ROLE role = RoleUtil.fromString(_prefs.getString('role')!);
      CustomerDetails details = CustomerDetails(
          customerId: '',
          firstName: firstName,
          lastName: lastName,
          email: '',
          dateOfBirth: DateTime.now());
      _auth.loginUser.currentCustomerDetails = details;
      _auth.loginUser.user = const User(
          id: 'offline',
          appMetadata: {},
          userMetadata: {},
          aud: '',
          createdAt: '');
      _auth.loginUser.role = role;
      _auth.loginUser.profileImageUrl = '';
      _auth.loginUser.fullName = '$firstName $lastName';
      if (role == ROLE.customer) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/recep_home');
      }
    }catch(e){
      _auth.loginUser.user = null;
      Get.offAll(()=>const LoginScreen());
    }

  }

  @override
  getCustomerName(String customerId) {
    return '${_prefs.getString('first_name')} ${_prefs.getString('last_name')}';
  }

  @Deprecated("Unimplemented")
  @override
  saveCustomer(
      {required String firstName,
      required String lastName,
      required DateTime dateOfBirth,
      String? imageUrl}) {
    throw UnimplementedError();
  }

  saveCustomerInPref(String firstName, String lastName, ROLE role) async {
    await _prefs.setString('first_name', firstName);
    await _prefs.setString('last_name', lastName);
    await _prefs.setString('role', RoleUtil.roleToString(role));
  }

  @override
  getId() => 0;

  @override
  getRole() {
    return RoleUtil.fromString(_prefs.getString('role')!);
  }

  @override
  void signOut() {
    _prefs.remove('first_name');
    _prefs.remove('last_name');
    _prefs.remove('role');
    Get.offAll(()=>const LoginScreen());
  }
}
