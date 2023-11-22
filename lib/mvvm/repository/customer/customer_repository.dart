abstract class CustomerRepository{
  getCustomerDetails(String id);
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