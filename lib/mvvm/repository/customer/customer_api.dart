import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/customer.dart';
import 'package:hotel_management/mvvm/model/customer_details.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_repository.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CustomerApi extends CustomerRepository {
  final _supabase = Supabase.instance.client;
  final _auth = Get.find<SupabaseAuthController>();

  @override
  getCustomerDetails(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('*').eq('id', id);
    if (ids.isEmpty || !await _customerDetailsExists(id)) {
      if (await _auth.googleSignInPlatform.isSignedIn()) {
        var metadata = _auth.loginUser.user!.userMetadata!;
        await Get.offNamed('/add_customer', arguments: {
          'firstName': metadata['full_name'].split(' ').first,
          'lastName': metadata['full_name'].split(' ').last,
          'imageUrl': metadata['avatar_url'],
        });
      } else {
        await Get.offNamed('/add_customer');
      }
      ids = await _supabase.from('customer').select('*').eq('id', id);
      if (ids.isEmpty) {}
    }
    String customerId = ids[0]['id'];
    var a = await _supabase
        .from('customer_details')
        .select('*')
        .eq('customer_id', customerId);

    _auth.loginUser.currentCustomerDetails =
        CustomerDetails.fromDynamicMap(a[0]);
    _auth.loginUser.user = _auth.currentUser();
    _auth.loginUser.role = RoleUtil.fromString(ids[0]['role']);
    _auth.loginUser.profileImageUrl = _auth
                .loginUser.user!.userMetadata?['avatar_url'] !=
            null
        ? _auth.loginUser.user!.userMetadata!['avatar_url']
        : _auth.loginUser.currentCustomerDetails.pictureUrl ??
            'https://www.pngall.com/wp-content/uploads/5/Profile-Avatar-PNG-Free-Download.png';
    _auth.loginUser.fullName = _auth
                .loginUser.user!.userMetadata?['full_name'] !=
            null
        ? _auth.loginUser.user!.userMetadata!['full_name']
        : '${_auth.loginUser.currentCustomerDetails.firstName} ${_auth.loginUser.currentCustomerDetails.lastName}';
    _auth.loginUser.role = _auth.loginUser.role;
    if (_auth.loginUser.role == ROLE.customer) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/recep_home');
    }
  }

  Future<bool> _customerDetailsExists(String id) async {
    List<dynamic> ids = await _supabase
        .from('customer_details')
        .select('customer_id')
        .eq('customer_id', id);
    if (ids.isEmpty) {
      return false;
    }
    return true;
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
  Future<String> getCustomerName(String customerId) async {
    return (await _supabase.from('customer').select('full_name').eq("id", customerId))[0]['full_name'];
  }
}
