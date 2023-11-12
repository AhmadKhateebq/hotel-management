import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view_model/request/request_preview_view_model.dart';

class PreviewRequest extends StatelessWidget {
  const PreviewRequest({
    super.key, required this.viewModel,
  });
  final RequestReviewViewModel viewModel ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close)),
        title: Text('Room ${viewModel.roomId} Requests'),
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
            Text('customer id : ${viewModel.customerId}'),
            Text('from date ${viewModel.startingDate}'),
            Text('to Date ${viewModel.endingDate}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(onPressed: viewModel.onDeny, child: const Text('deny')),
                const SizedBox(
                  width: 10,
                ),
                OutlinedButton(
                    onPressed: viewModel.onApprove, child: const Text('Approve')),
              ],
            ),
            OutlinedButton(
                onPressed: viewModel.onAutoApprove, child: const Text('Auto Approve')),
          ],
        ),
      ),
    );
  }
}
