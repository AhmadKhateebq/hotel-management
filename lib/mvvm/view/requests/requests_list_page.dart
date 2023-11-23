import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/view/requests/room_request_detail.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';
import 'package:hotel_management/mvvm/view_model/request/room_request_details_view_model.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatefulWidget {
  const RequestsList({super.key, required this.viewModel});

  final RequestsListViewModel viewModel;

  @override
  State<RequestsList> createState() => _RequestsListState();
}

class _RequestsListState extends State<RequestsList> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestsListViewModel>(
      lazy: false,
      create: (context) {
        var newViewModel = RequestsListViewModel(
            pending: widget.viewModel.pending,
            approved: widget.viewModel.approved,
            intertwined: widget.viewModel.intertwined,
            denied: widget.viewModel.denied);
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
  @override
  void dispose() {
    Provider
        .of<RequestsListViewModel>(context).dispose();
    super.dispose();
  }
}
