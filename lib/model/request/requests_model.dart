import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/repository/room_requests_repository_impl.dart';
import 'package:hotel_management/util/util_classes.dart';

abstract class RequestModel {
  final RoomRequestRepositoryImpl requestRepository =
      RoomRequestRepositoryImpl();
  List<RoomRequest> requests = <RoomRequest>[];

  Stream<List<Map<String, dynamic>>> get stream =>
      requestRepository.getStream();

  List<RoomRequest> filteredRequests = <RoomRequest>[];
  bool pending = false;
  bool approved = false;
  bool intertwined = false;
  bool denied = false;
  bool myRequests = false;

  Future<void> getRequests();

  bool filterRequests(RoomRequest request) {
    bool a = true;
    if (approved ) {
      a = request.status == STATUS.approved;
    }
    if (pending) {
      a = request.status == STATUS.pending;
    }
    if (intertwined) {
      a = request.status == STATUS.reserved;
    }
    if (denied ) {
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
    this.pending = pending ?? false;
    this.denied = denied ?? false;
    this.approved = approved ?? false;
    this.intertwined = intertwined ?? false;
  }

  Future<void> updateData();

  void setRequests(List<RoomRequest> temp) {
    requests = temp;
  }

  void updateWithData(List<RoomRequest> requests) {
    this.requests = requests;
    filteredRequests = requests.where(filterRequests).toList();
  }
}
