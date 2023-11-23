import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/view/requests/request_details_view.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

import 'request_preview_view_model.dart';

class RoomRequestDetailsViewModel {
  RoomRequestDetailsViewModel({required RoomRequest request})
      : _request = request;
  final RoomRequest _request;

  get roomId => _request.roomId;

  get madeOn => DateFormatter.formatWithTime(_request.time);

  get startingDate => DateFormatter.format(_request.startingDate);

  get endingDate => DateFormatter.format(_request.endingDate);

  cardOnTap() {
    Get.to(
      () => PreviewRequest(
        viewModel: RequestReviewViewModel(
          request: _request,
        ),
      ),
      duration: const Duration(milliseconds: 500),
      transition: Transition.circularReveal,
      curve: Curves.easeInExpo,
    );
  }
}
