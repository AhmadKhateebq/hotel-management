import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/preview_request.dart';
import 'package:hotel_management/controller/requests_controller.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

class RequestsListView extends StatefulWidget {
  const RequestsListView({super.key});

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
                  .toList() ??
              [];
          return ListView.builder(
            itemCount: requests.length,
            itemBuilder: (context, index) {
              RoomRequest request = requests[index];
              return listTileBuilder(request);
            },
          );
        });
  }

  ListTile listTileBuilder(RoomRequest request) {
    return ListTile(
      title: Text('room ${request.roomId}'),
      subtitle: Text(RoomRequest.getStatusString(request.status)),
      onTap: () => listTileOnTap(request),
    );
  }

  listTileOnTap(RoomRequest request) async {
    Get.to(preview(request));
  }
  preview(RoomRequest request) => PreviewRequest(
    customerId: request.customerId,
    startingDate: DateFormatter.formatWithTime(request.startingDate),
    endingDate: DateFormatter.formatWithTime(request.endingDate),
    requestTime: DateFormatter.formatWithTime(request.time),
    roomId: request.roomId,
    requestId: request.id.toString(),
    status: RoomRequest.getStatusString(request.status), controller: Get.find(),);
}
