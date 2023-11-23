import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/customer.dart';
import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/mvvm/model/login_user_model.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_offlne.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/mvvm/view/add_new_customer.dart';
import 'package:hotel_management/mvvm/view_model/add_new_customer_view_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerApi extends CustomerRepository {
  final _supabase = Supabase.instance.client;
  final _auth = Get.find<SupabaseAuthController>();

  @override
  getRole() => _auth.loginUser.role;

  @override
  getId() => _auth.loginUser.user!.id;

  @override
  getCustomerDetails(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('*').eq('id', id);
    if (ids.isEmpty) {
      if (await _auth.googleSignInPlatform.isSignedIn()) {
        var metadata = _auth.loginUser.user!.userMetadata!;
        await Get.off(() => AddCustomer(viewModel: AddNewCustomerViewModel()),
            arguments: {
              'firstName': metadata['full_name'].split(' ').first,
              'lastName': metadata['full_name'].split(' ').last,
              'imageUrl': metadata['avatar_url'],
            });
      } else {
        await Get.off(AddCustomer(viewModel: AddNewCustomerViewModel()));
      }
      ids = await _supabase.from('customer').select('*').eq('id', id);
      if (ids.isEmpty) {}
    }
    String customerId = ids[0]['id'];
    var customerDetailsFromApi = await _supabase
        .from('customer_details')
        .select('*')
        .eq('customer_id', customerId);
    var details = CustomerDetails.fromDynamicMap(customerDetailsFromApi[0]);
    var user = _auth.currentUser();
    var role = RoleUtil.fromString(ids[0]['role']);
    late String imageUrl;
    late String fullName;
    if (user!.userMetadata?['avatar_url'] != null) {
      imageUrl = user.userMetadata!['avatar_url'];
    } else {
      if (details.pictureUrl != null) {
        imageUrl = details.pictureUrl!;
      } else {
        imageUrl =
            'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
      }
    }
    if (user.userMetadata?['full_name'] != null) {
      fullName = user.userMetadata!['full_name'];
    } else {
      fullName = '${details.firstName} ${details.lastName}';
    }
    _auth.loginUser = LoginUser.initialized(
        currentCustomerDetails: details,
        imageUrl: imageUrl,
        fullName: fullName,
        role: role, user: user);
    FirebaseAnalytics analytics = FirebaseAnalytics.instance;
    await analytics.setUserProperty(
        name: 'full_name', value: _auth.loginUser.fullName);
    await CustomerLocal()
        .saveCustomerInPref(details.firstName, details.lastName, role);
    return role;
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

  @override
  saveCustomer(
      {required String firstName,
      required String lastName,
      required DateTime dateOfBirth,
      String? imageUrl}) async {
    var user = Get.find<SupabaseAuthController>().loginUser.user;
    var customerId = user!.id;
    String email = user.email!;
    CustomerDetails details = CustomerDetails(
        customerId: customerId,
        firstName: firstName,
        lastName: lastName,
        email: email,
        dateOfBirth: dateOfBirth,
        pictureUrl: imageUrl ?? noImage);
    Customer customer = Customer(
        id: customerId,
        reserving: false,
        fullName: '$firstName $lastName',
        role: ROLE.customer);
    if (!(await _customerExists(customerId))) {
      await _saveCustomer(customer);
    }
    await _saveCustomerDetails(details);
  }

  @override
  Future<String> getCustomerName(String customerId) async {
    return (await _supabase
        .from('customer')
        .select('full_name')
        .eq("id", customerId))[0]['full_name'];
  }

  @override
  void signOut() {
    _auth.signOut();
  }
}
