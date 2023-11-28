import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/repository/room_requests_repository_impl.dart';
import 'package:hotel_management/util/util_classes.dart';

class RequestModel {
  final RoomRequestRepositoryImpl requestRepository = RoomRequestRepositoryImpl();
  List<RoomRequest> _requests = <RoomRequest>[];
  List<RoomRequest> _myRequests = <RoomRequest>[];
  List<RoomRequest> filteredRequests = <RoomRequest>[];
  bool? pending = false;
  bool? approved = false;
  bool? intertwined = false;
  bool? denied = false;
  bool myRequests = false;

  void setUpListener(void Function() updateRequests) {
    requestRepository.setUpListener(updateRequests);
  }

  getRequests() async {
    if (_requests.isNotEmpty) {
      filteredRequests = _requests.where(filterRequests).toList();
    } else {
      var temp = (await requestRepository.getRoomRequests())
          .where(filterRequests)
          .toList();
      if (_requests != temp) {
        _requests = temp;
        filteredRequests = temp;
      }
    }
  }

  getMyRequests() async {
    if (_myRequests.isNotEmpty) {
      filteredRequests = _myRequests.where(filterRequests).toList();
    } else {
      var temp = (await requestRepository.getMyRoomRequests())
          .where(filterRequests)
          .toList();
      if (_myRequests != temp) {
        _myRequests = temp;
        filteredRequests = temp;
      }
    }
  }

  bool filterRequests(RoomRequest request) {
    bool a = true;
    if (approved ?? false) {
      a = request.status == STATUS.approved;
    }
    if (pending ?? false) {
      a = request.status == STATUS.pending;
    }
    if (intertwined ?? false) {
      a = request.status == STATUS.reserved;
    }
    if (denied ?? false) {
      a = request.status == STATUS.denied;
    }
    return a;
  }

  void setUpFlags(
      {bool? pending,
      bool? denied,
      bool? approved,
      bool? intertwined,
      required bool myRequests}) {
    this.myRequests = myRequests;
    this.pending = pending;
    this.denied = denied;
    this.approved = approved;
    this.intertwined = intertwined;
  }

  Future<void> updateData() async {
    await requestRepository.refreshData();
     _myRequests = (await requestRepository.getMyRoomRequests())
        .toList();
     _requests = (await requestRepository.getRoomRequests())
         .toList();
  }
}
