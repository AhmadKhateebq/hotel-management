import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/model/customer.dart';
import 'package:hotel_management/model/customer_details.dart';
import 'package:hotel_management/model/room.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseDatabaseController {
  final _supabase = Supabase.instance.client;
  late CustomerDetails currentCustomerDetails;
  late ROLE _currentCustomerRole;
  DateTime start = DateTime.now();
  DateTime end = DateTime.now();

  ROLE get currentCustomerRole => _currentCustomerRole;

  Future<void> _saveCustomerDetails(CustomerDetails details) async {
    await _supabase.from('customer_details').insert(details);
  }

  Future<void> _saveCustomer(Customer customer) async {
    await _supabase.from('customer').insert(customer);
  }

  Future<void> saveRoom(Room room) async {
   return await _supabase.from('room').insert(room);
  }

  Future<bool> roomExists(String id) async {
    List<dynamic> ids =
        await _supabase.from('room').select('room_id').eq('room_id', id);
    print(ids.toString());
    if (ids.isEmpty) {
      return false;
    }
    return true;
  }

  Future<bool> _customerExists(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('id').eq('id', id);
    print(ids.toString());
    if (ids.isEmpty) {
      return false;
    }
    return true;
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

  getCustomerDetails(String id) async {
    List<dynamic> ids =
        await _supabase.from('customer').select('*').eq('id', id);
    if (ids.isEmpty || !await _customerDetailsExists(id)) {
      if (await Get.find<SupabaseAuthController>()
          .googleSignInPlatform
          .isSignedIn()) {
        var metadata = Get.find<SupabaseAuthController>().user!.userMetadata!;
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
    currentCustomerDetails = CustomerDetails.fromDynamicMap(a[0]);
    _currentCustomerRole = Role.fromString(ids[0]['role']);
    if (_currentCustomerRole == ROLE.customer) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/recep_home');
    }
  }

  saveCustomer(
      {required String firstName,
      required String lastName,
      required DateTime dateOfBirth,
      String? imageUrl}) async {
    var user = Get.find<SupabaseAuthController>().user;
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
    await Get.find<SupabaseDatabaseController>()._saveCustomerDetails(details);
  }

  Stream<List<Map<String, dynamic>>> getRoomsStream() {
    return _supabase.from('room').stream(primaryKey: ['room_id']);
  }

  Future<List<Room>> getEmptyRooms(
      {required DateTime start, required DateTime end}) async {
    List<dynamic> a = await _supabase.rpc('get_rooms', params: {
      "start": DateFormatter.format(start),
      'end_date': DateFormatter.format(end)
    });
    return a.map((e) => Room.fromDynamicMap(e as Map)).toList()..sort();
  }
}

// ignore: unused_element
class _Methods extends SupabaseDatabaseController {
  getData() async {
    final data = await _supabase.from('cities').select('name');
    return data;
  }

  getDataFilters() async {
    var myList = [];
    final data = await _supabase
        .from('cities')
        .select('name')
        .filter('arraycol', 'cs',
            '{"a","b"}') // Use Postgres array {} and 'cs' for contains.
        .filter('rangecol', 'cs',
            '(1,2]') // Use Postgres range syntax for range column.
        .filter('id', 'in',
            '(6,7)') // Use Postgres list () and 'in' for in_ filter.
        .filter('id', 'cs',
            '{${myList.join(',')}}'); // You can insert a Dart array list.;
    return data;
  }

  getDataFiltered() async {
    final data = await _supabase
            .from('cities')
            .select('name, country_id')
            .eq('name', 'The Shire') //equal
            .neq('name', 'The shire') //not equal
            .gt('country_id', 250) //greater than
            .gte('country_id', 250) //greater than or equal
            .lt('country_id', 250) //less than
            .lte('country_id', 250) //less than or equal
            .like('name', '%la%') //match pattern
            .ilike('name', '%la%') //matches case insensitive
            .is_('name', null) //is value
            .in_('name', ['Rio de Janeiro', 'San Francisco']) //in array
            .contains('main_exports',
                ['oil']) //Column contains every element in a value
        //more on than in $docs in consts

        ;
    return data;
  }

  insertData() async {
    await _supabase
        .from('cities')
        .insert({'name': 'The Shire', 'country_id': 554});
  }

  updateData() async {
    await _supabase
        .from('cities')
        .update({'name': 'Middle Earth'}).match({'name': 'Auckland'});
  }

  deleteData() async {
    await _supabase.from('cities').delete().match({'id': 666});
  }
}
