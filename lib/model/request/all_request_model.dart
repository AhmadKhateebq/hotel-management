import 'package:hotel_management/model/request/requests_model.dart';

class AllRequestModel extends RequestModel {
  @override
  getRequests() async {
    if (requests.isEmpty) {
      setRequests(await requestRepository.getRoomRequests());
    }
    filteredRequests = requests.where(filterRequests).toList();
  }

  @override
  Future<void> updateData() async {
    await requestRepository.refreshData();
  }

  @override
  Stream<List<Map<String, dynamic>>> get stream =>
  requestRepository.getStream();
}
