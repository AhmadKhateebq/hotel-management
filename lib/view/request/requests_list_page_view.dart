import 'package:flutter/material.dart';
import 'package:hotel_management/component/request/room_request_card.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/view_model/request/request_list_view_model.dart';
import 'package:provider/provider.dart';

class RequestsList extends StatelessWidget {
  const RequestsList({
    super.key,
    required this.pending,
    required this.approved,
    required this.intertwined,
    required this.denied,
    required this.myRequests,
  });

  final bool pending;
  final bool approved;
  final bool intertwined;
  final bool denied;
  final bool myRequests;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RequestsListViewModel>(
      lazy: false,
      create: (context) {
        var newViewModel = RequestsListViewModel(
            pending: pending,
            approved: approved,
            intertwined: intertwined,
            denied: denied,
            myRequests: myRequests);
        newViewModel.init();
        return newViewModel;
      },
      builder: (context, child) => ListView.builder(
        itemCount: Provider.of<RequestsListViewModel>(context).length,
        itemBuilder: (context, index) {
          List<RoomRequest> requests =
              Provider.of<RequestsListViewModel>(context).requests;
          return RoomRequestCard(
            request: requests[index],
            onTap: () => Provider.of<RequestsListViewModel>(context,listen: false)
                .cardOnTap(requests[index]),
          );
        },
      ),
    );
  }
}
