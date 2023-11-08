import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/scaffold_widget.dart';
import 'package:hotel_management/controller/requests_controller.dart';

class PreviewRequest extends StatelessWidget {
  const PreviewRequest(
      {super.key,
      required this.customerId,
      required this.startingDate,
      required this.endingDate,
      required this.requestTime,
      required this.roomId,
      required this.requestId,
      required this.status,
      required this.controller});

  final String customerId;
  final String requestId;
  final String startingDate;
  final String endingDate;
  final String requestTime;
  final String roomId;
  final String status;
  final RoomRequestController controller;

  @override
  Widget build(BuildContext context) {
    return ScaffoldBuilder(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        backgroundColor: Colors.redAccent,
        title: Text('Room $roomId Requests'),
        centerTitle: true,
      ),
      title: "$roomId request",
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('request id : $requestId'),
            Text('requestTime : $requestTime'),
            Text('status : $status'),
            Text('customer id : $customerId'),
            Text('from date $startingDate'),
            Text('to Date $endingDate'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: deny, child: const Text('deny')),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: approve, child: const Text('Approve')),
              ],
            ),
            OutlinedButton(
                onPressed: autoApprove, child: const Text('Auto Approve')),
          ],
        ),
      ),
    );
  }

  approve() {
    controller.approve(int.parse(requestId), roomId);
    Get.back();
  }

  autoApprove() {
    controller.autoApprove(roomId);
    Get.back();
  }

  deny() {
    controller.deny(int.parse(requestId), roomId);
    Get.back();
  }
}
