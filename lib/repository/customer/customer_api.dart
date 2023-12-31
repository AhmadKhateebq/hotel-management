import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/interface/customer.dart';
import 'package:hotel_management/interface/customer_details.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:hotel_management/view/add_new_customer_view.dart';
import 'package:hotel_management/view_model/add_new_customer_view_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerApi {
   final SupabaseClient _supabase =  Get.find<SupabaseController>().client;
  final _prefs = Get.find<SharedPrefController>().reference;


  Future<String> getCustomerName(String customerId) async {
    try {
      return (await _supabase
              .from('customer')
              .select<List>('full_name')
              .eq('id', customerId))
          .first['full_name'];
    } catch (e) {
      return '';
    }
  }

  getCustomerDetails(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('*').eq('id', id);
    if (ids.isEmpty) {
      await Get.to(AddCustomer(viewModel: AddNewCustomerViewModel()));
      ids = await _supabase.from('customer').select('*').eq('id', id);
      if (ids.isEmpty) {}
    }
    String customerId = ids[0]['id'];
    var customerDetailsFromApi = await _supabase
        .from('customer_details')
        .select('*')
        .eq('customer_id', customerId);
    var details = CustomerDetails.fromDynamicMap(customerDetailsFromApi[0]);
    var role = RoleUtil.fromString(ids[0]['role']);
    late String imageUrl;
    late String fullName;
    if (details.pictureUrl != null) {
      imageUrl = details.pictureUrl!;
    } else {
      imageUrl =
          'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
    }
    fullName = '${details.firstName} ${details.lastName}';
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setUserProperty(name: 'full_name', value: fullName);
    await saveCustomerInPref(
        firstName: details.firstName,
        lastName: details.lastName,
        customerId: id,
        profileImageUrl: details.pictureUrl??noImage,
        role: role,
        userImage: imageUrl);
  }

  Future<void> _saveCustomerDetails(CustomerDetails details) async {
    await _supabase.from('customer_details').insert(details);
  }

  Future<void> _saveCustomer(Customer customer) async {
    await _supabase.from('customer').insert(customer);
  }

  Future<bool> _customerExists(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('id').eq('id', id);
    if (ids.isEmpty) {
      return false;
    }
    return true;
  }

  saveCustomer(
      {required String firstName,
      required String lastName,
      required DateTime dateOfBirth,
      String? imageUrl}) async {
    CustomerDetails details = CustomerDetails(
        customerId: _supabase.auth.currentUser!.id,
        firstName: firstName,
        lastName: lastName,
        email: _supabase.auth.currentUser!.email!,
        dateOfBirth: dateOfBirth,
        pictureUrl: imageUrl ?? noImage);
    Customer customer = Customer(
        id: _supabase.auth.currentUser!.id,
        reserving: false,
        fullName: '$firstName $lastName',
        role: ROLE.customer);
    if (!(await _customerExists(_supabase.auth.currentUser!.id))) {
      await _saveCustomer(customer);
    }
    await _saveCustomerDetails(details);
  }

  saveCustomerInPref({
    required String firstName,
    required String lastName,
    required String profileImageUrl,
    required ROLE role,
    required String userImage,
    required String customerId,
  }) async {
    Get.find<UserModel>().saveDetails(
        profileImageUrl: profileImageUrl,
        firstName: firstName,
        lastName: lastName,
        customerId: customerId,
        role: RoleUtil.roleToString(role));
  }

  void signOut() {
    _prefs.remove('first_name');
    _prefs.remove('last_name');
    _prefs.remove('role');
  }
}
