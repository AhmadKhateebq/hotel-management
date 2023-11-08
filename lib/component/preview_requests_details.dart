import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/preview_request.dart';
import 'package:hotel_management/model/request.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

class RequestsPreviewList extends StatelessWidget {
  const RequestsPreviewList({super.key, this.initialPage, required this.list});

  final int? initialPage;
  final List<RoomRequest> list;

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: initialPage ?? 0);
    return  SafeArea(
      child: PageView(
          allowImplicitScrolling: true,
          scrollDirection: Axis.horizontal,
          controller: controller,
          children: _list,
      ),
    );
  }

  List<PreviewRequest> get _list {
    List<PreviewRequest> requests = [];
    for (RoomRequest value in list) {
      requests.add(PreviewRequest(
        customerId: value.customerId,
        startingDate: DateFormatter.format(value.startingDate),
        endingDate:  DateFormatter.format(value.endingDate),
        requestTime: DateFormatter.formatWithTime(value.time),
        roomId: value.roomId,
        requestId: value.id.toString(),
        status: RoomRequest.getStatusString(value.status),
        controller: Get.find(),
      ));
    }
    return requests;
  }
}
