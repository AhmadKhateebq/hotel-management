import 'package:get/get.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/view/requests/request_details_view.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

import 'request_preview_view_model.dart';

class RoomRequestDetailsViewModel{
  final RoomRequest _request;

  RoomRequestDetailsViewModel({required RoomRequest request}) : _request = request;
  get roomId => _request.roomId;

  get madeOn => DateFormatter.formatWithTime(_request.time);

  get startingDate => DateFormatter.format(_request.startingDate);

  get endingDate => DateFormatter.format(_request.endingDate);


  cardOnTap()  {
    print('onTap');
    Get.to(() => PreviewRequest(
      viewModel: RequestReviewViewModel(request: _request),
    ));

  }

}