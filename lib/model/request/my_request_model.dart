import 'package:hotel_management/model/request/requests_model.dart';

class MyRequestModel extends RequestModel {
  @override
  getRequests() async {
    if (requests.isNotEmpty) {
      filteredRequests = requests.where(filterRequests).toList();
    } else {
      var temp = (await requestRepository.getMyRoomRequests())
          .where(filterRequests)
          .toList();
      if (requests != temp) {
        requests = temp;
        filteredRequests = temp;
      }
    }
  }

  @override
  Future<void> updateData() async {
    await requestRepository.refreshMyData();
  }
}
