import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view/requests/request_details_view.dart';
import 'package:hotel_management/mvvm/view_model/request/request_page_view_model_view.dart';
import 'package:hotel_management/mvvm/view_model/request/request_preview_view_model.dart';

class RequestsPageView extends StatelessWidget {
  const RequestsPageView({super.key, required this.modelView});

  final RequestsPageViewModelView modelView;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PageView(
        allowImplicitScrolling: true,
        scrollDirection: Axis.horizontal,
        controller: modelView.pageController,
        children: _buildPreviewRequests(),
      ),
    );
  }

  List<PreviewRequest> _buildPreviewRequests() {
    return modelView.list.map((value) {
      return PreviewRequest(
        viewModel: RequestReviewViewModel(
            request: value,),
      );
    }).toList();
  }
}
