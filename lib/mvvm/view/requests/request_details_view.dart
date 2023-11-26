import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/request/request_preview_view_model.dart';

class PreviewRequest extends StatefulWidget {
  const PreviewRequest({
    super.key,
    required this.viewModel,
  });

  final RequestReviewViewModel viewModel;

  @override
  State<PreviewRequest> createState() => _PreviewRequestState();
}

class _PreviewRequestState extends State<PreviewRequest> {
  @override
  void initState() {
    widget.viewModel.getCustomerName();
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
        title: Text('Room ${widget.viewModel.roomId} Request'),
        centerTitle: true,
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('request id : ${widget.viewModel.requestId}'),
            Text('requestTime : ${widget.viewModel.requestTime}'),
            Text('status : ${widget.viewModel.status}'),
            Obx(() =>
                Text('customer Name : ${widget.viewModel.customerName.value}')),
            Text('from date ${widget.viewModel.startingDate}'),
            Text('to Date ${widget.viewModel.endingDate}'),
            getButtons(),
          ],
        ),
      ),
    );
  }
  getButtons() =>widget.viewModel.getButtons?
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                  onPressed: widget.viewModel.onDeny,
                  child: const Text('deny')),
              const SizedBox(
                width: 10,
              ),
              OutlinedButton(
                  onPressed: widget.viewModel.onApprove,
                  child: const Text('Approve')),
            ],
          ),
          OutlinedButton(
              onPressed: widget.viewModel.onAutoApprove,
              child: const Text('Auto Approve')),
        ],
      ):const SizedBox();
}
