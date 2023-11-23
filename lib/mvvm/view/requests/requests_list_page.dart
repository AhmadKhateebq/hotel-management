import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/view/requests/room_request_detail.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';
import 'package:hotel_management/mvvm/view_model/request/room_request_details_view_model.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key, required this.viewModel});

  final RequestsListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestsListViewModel>(
      lazy: false,
      create: (context) {
        var newViewModel = RequestsListViewModel(
            pending: viewModel.pending,
            approved: viewModel.approved,
            intertwined: viewModel.intertwined,
            denied: viewModel.denied);
        newViewModel.updateRequests();
        return newViewModel;
      },
      builder: (context, child) =>
          ListView.builder(
            itemCount: Provider
                .of<RequestsListViewModel>(context)
                .length,
            itemBuilder: (context, index) {
              List<RoomRequest> requests = Provider
                  .of<RequestsListViewModel>(context)
                  .requests;
              return RoomRequestDetails(
                  viewModel:
                  RoomRequestDetailsViewModel(request: requests[index]));
            },
          ),
    );
  }
}
