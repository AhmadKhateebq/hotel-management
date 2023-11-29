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

  TextStyle get labelStyle =>
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey);

  TextStyle get detailStyle => const TextStyle(fontWeight: FontWeight.bold);

  get divider => const Divider(
        height: 20,
        thickness: 1,
        indent: 20,
        endIndent: 0,
        color: Colors.grey,
      );

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
          children: [
            Expanded(
              flex: 4,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Request Id',
                        style: labelStyle,
                      ),
                      divider,
                      Text('Request Time', style: labelStyle),
                      divider,
                      Text('Request Status', style: labelStyle),
                      divider,
                      Text('Customer Name', style: labelStyle),
                      divider,
                      Text('Arrival Date', style: labelStyle),
                      divider,
                      Text('Departure Date', style: labelStyle),
                    ],
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  const VerticalDivider(
                    width: 20,
                    thickness: 1,
                    indent: 20,
                    endIndent: 0,
                    color: Colors.grey,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(' ${viewModel.requestId}', style: detailStyle),
                      divider,
                      Text(' ${viewModel.requestTime}', style: detailStyle),
                      divider,
                      Text(' ${viewModel.status}', style: detailStyle),
                      divider,
                      Obx(
                        () => Text(viewModel.customerName.value,
                            style: detailStyle),
                      ),
                      divider,
                      Text('${viewModel.startingDate}', style: detailStyle),
                      divider,
                      Text('${viewModel.endingDate}', style: detailStyle),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(flex: 1, child: getButtons()),
          ],
        ),
      ),
    );
  }

  Widget getButtons() => viewModel.getButtons
      ? Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
                onPressed: viewModel.onDeny, child: const Text('deny')),
            OutlinedButton(
                onPressed: viewModel.onApprove, child: const Text('Approve')),
            OutlinedButton(
                onPressed: viewModel.onAutoApprove,
                child: const Text('Auto Approve')),
          ],
        )
      : const SizedBox();
}
