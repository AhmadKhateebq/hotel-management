import 'package:hotel_management/model/request/requests_model.dart';

class MyRequestModel extends RequestModel {
  @override
  getRequests() async {
    if (requests.isEmpty) {
      setRequests(await requestRepository.getMyRoomRequests());
    }
    filteredRequests = requests.where(filterRequests).toList();
  }

  @override
  Future<void> updateData() async {
    await requestRepository.refreshMyData();
  }

  @override
  Stream<List<Map<String, dynamic>>> get stream =>
      requestRepository.getMyStream();


}
