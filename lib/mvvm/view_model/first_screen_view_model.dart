import 'package:get/get.dart';
import 'package:hotel_management/controller/app_lifecycle_reactor.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/controller/google_adds_controller.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';

class FirstScreenViewModel{
  final SupabaseAuthController _authController = Get.find();
  final CustomerApi _customerApi = CustomerApi();
  RxBool isLoading = true.obs;
  init() async {

    isLoading.value = true;
    if(_authController.currentUser() != null){
      await _customerApi.getCustomerDetails(_authController.currentUser()!.id);
      _authController.getUserData();
    }
    else{
      isLoading.value = false;
    }
  }
}