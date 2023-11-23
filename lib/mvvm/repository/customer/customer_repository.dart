import 'package:hotel_management/util/util_classes.dart';

abstract class CustomerRepository{
  Future<ROLE> getCustomerDetails(String id);
  getCustomerName(String customerId);
  saveCustomer(
      {required String firstName,
        required String lastName,
        required DateTime dateOfBirth,
        String? imageUrl});
  getRole();
  getId();

  void signOut();
}