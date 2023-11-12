import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/repository/request/requests_api.dart';
import 'package:hotel_management/util/date_formatter_util.dart';


class RequestReviewViewModel {
  final RoomRequest _request;

  RequestReviewViewModel({required RoomRequest request}) : _request = request;
  final RoomRequestApi requestApi = RoomRequestApi();

  get request => _request;

  get customerId => _request.customerId;

  get startingDate => DateFormatter.format(_request.startingDate);

  get endingDate => DateFormatter.format(_request.endingDate);

  get requestTime => DateFormatter.formatWithTime(_request.time);

  get roomId => _request.roomId;

  get requestId => _request.id.toString();

  get status => RoomRequest.getStatusString(_request.status);

  get onApprove =>
      () async {
        await requestApi.approve(_request.id, _request.roomId);
        Get.back();
      };

  get onAutoApprove => () async {
    await requestApi.autoApprove(_request.roomId);
    Get.back();
  };

  get onDeny => () async {
    await requestApi.deny(_request.id, _request.roomId);
    Get.back();
  };
}
