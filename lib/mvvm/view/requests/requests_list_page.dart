import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view/requests/room_request_detail.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';
import 'package:hotel_management/mvvm/view_model/request/room_request_details_view_model.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({super.key, required this.viewModel});

  final RequestsListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: viewModel.dataStream,
        builder: (context, snapshot) {
          viewModel.handleSnapshot(snapshot);
          return ListView.builder(
            itemCount: viewModel.length,
            itemBuilder: (context, index) {
              return RoomRequestDetails(
                  viewModel: RoomRequestDetailsViewModel(
                      request: viewModel.request(index)));
            },
          );
        });
  }
}
