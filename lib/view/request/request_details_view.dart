import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/view_model/request/request_preview_view_model.dart';

class PreviewRequest extends StatefulWidget {
  const PreviewRequest({
    super.key,
    required this.request,
  });

  final RoomRequest request;

  @override
  State<PreviewRequest> createState() => _PreviewRequestState();
}

class _PreviewRequestState extends State<PreviewRequest> {
  late RequestReviewViewModel viewModel;

  @override
  void initState() {
    viewModel = RequestReviewViewModel(request: widget.request);
    viewModel.getCustomerName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        title: Text('Room ${viewModel.roomId} Request'),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('request id : ${viewModel.requestId}'),
            Text('requestTime : ${viewModel.requestTime}'),
            Text('status : ${viewModel.status}'),
            Obx(() => Text('customer Name : ${viewModel.customerName.value}')),
            Text('from date ${viewModel.startingDate}'),
            Text('to Date ${viewModel.endingDate}'),
            getButtons(),
          ],
        ),
      ),
    );
  }

  getButtons() => viewModel.getButtons
      ? Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                    onPressed: viewModel.onDeny, child: const Text('deny')),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: viewModel.onApprove,
                    child: const Text('Approve')),
              ],
            ),
            OutlinedButton(
                onPressed: viewModel.onAutoApprove,
                child: const Text('Auto Approve')),
          ],
        )
      : const SizedBox();
}
