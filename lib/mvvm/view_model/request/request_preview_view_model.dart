import 'package:get/get.dart';
import 'package:hotel_management/controller/shared_pref_controller.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/customer/customer_api.dart';
import 'package:hotel_management/mvvm/repository/request/room_request_repository.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';

class RequestReviewViewModel {
  RequestReviewViewModel({
    required RoomRequest request,
  }) : _request = request;

  final RoomRequest _request;
  final RoomRequestRepository requestApi = Get.find();
  var customerName = ''.obs;

  get request => _request;

  get getButtons => (_request.status == STATUS.pending &&
      SharedPrefController.reference.getString('role') != 'customer');

  getCustomerName() async {
    Get.find<CustomerApi>().getCustomerName(_request.customerId).then((value) => customerName.value = value);
  }

  get startingDate => DateFormatter.format(_request.startingDate);

  get endingDate => DateFormatter.format(_request.endingDate);

  get requestTime => DateFormatter.formatWithTime(_request.time);

  get roomId => _request.roomId;

  get requestId => _request.id.toString();

  get status => StatusUtil.getStatusString(_request.status);

  get onApprove => () async {
        await requestApi.approve(_request.id!, _request.roomId);
        Get.back();
      };

  get onAutoApprove => () async {
        await requestApi.autoApprove(_request.roomId);
        Get.back();
      };

  get onDeny => () async {
        await requestApi.deny(_request.id!, _request.roomId);
        Get.back();
      };
}
