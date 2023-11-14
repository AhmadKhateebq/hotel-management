import 'package:flutter/src/widgets/async.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/util/util_classes.dart';

class RequestsListViewModel {
  final bool? pending;
  final bool? approved;
  final bool? intertwined;
  final bool? denied;
  final Stream<List<Map<String, dynamic>>> dataStream;
  final RoomRequest Function(Map<String, dynamic> data) mapper;
  List<RoomRequest> requests = [];

  RequestsListViewModel(
      {required this.pending,
      required this.approved,
      required this.intertwined,
      required this.denied,
      required this.dataStream,
      required this.mapper});

  get length => requests.length;

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

  void handleSnapshot(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    requests = snapshot.data?.map(mapper).where(filterRequests).toList() ?? [];
    requests.sort();
  }

  request(int index) => requests[index];
}
