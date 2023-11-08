import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/preview_request.dart';
import 'package:hotel_management/component/preview_requests_details.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/util/date_formatter_util.dart';
import 'package:hotel_management/util/util_classes.dart';

class RequestsListView extends StatefulWidget {
  const RequestsListView(
      {super.key, this.pending, this.approved, this.intertwined, this.denied});

  final bool? pending;

  final bool? approved;

  final bool? intertwined;

  final bool? denied;

  @override
  State<RequestsListView> createState() => _RequestsListViewState();
}

class _RequestsListViewState extends State<RequestsListView> {
  final RoomRequestController requestsController = Get.find();
  late Stream<List<Map<String, dynamic>>> _stream;

  @override
  void initState() {
    _stream = requestsController.getRequestsStream();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _stream,
        builder: (context, snapshot) {
          List<RoomRequest> requests = snapshot.data
                  ?.map((e) => RoomRequest.fromDynamicMap(e))
                  .where(filterRequests)
                  .toList() ??
              [];
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              RoomRequest request = requests[index];
              return listTileBuilder(request,index,requests);
            },
          );
        });
  }

  bool filterRequests(RoomRequest request) {
    bool a = true;
    if(widget.approved??false){
      a = request.status == STATUS.approved;
    }
    if(widget.pending??false){
      a = request.status == STATUS.pending;
    }
    if(widget.intertwined??false){
      a = request.status == STATUS.reserved;
    }
    if(widget.denied??false){
      a = request.status == STATUS.denied;
    }
    return a;
  }

  Widget listTileBuilder(RoomRequest request,int index,List<RoomRequest> requests) {
    return Card(
      child: ListTile(
        title: Text('Room ${request.roomId}'),
        subtitle: Text('Made On:${DateFormatter.formatWithTime(request.time)}'),
        trailing: Text('${DateFormatter.format(request.startingDate)} - ${DateFormatter.format(request.endingDate)}'),
        onTap: () => listTileOnTap(request,index,requests),
      ),
    );
  }

  listTileOnTap(RoomRequest request,int index,List<RoomRequest> requests) async {
    Get.to(() =>RequestsPreviewList(list: requests,initialPage: index,) );
    // Get.to(preview(request));
  }

  preview(RoomRequest request) => PreviewRequest(
        customerId: request.customerId,
        startingDate: DateFormatter.formatWithTime(request.startingDate),
        endingDate: DateFormatter.formatWithTime(request.endingDate),
        requestTime: DateFormatter.formatWithTime(request.time),
        roomId: request.roomId,
        requestId: request.id.toString(),
        status: RoomRequest.getStatusString(request.status),
        controller: Get.find(),
      );
}
