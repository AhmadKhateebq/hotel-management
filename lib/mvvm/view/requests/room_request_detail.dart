import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view_model/request/room_request_details_view_model.dart';

class RoomRequestDetails extends StatelessWidget {
  const RoomRequestDetails({super.key, required this.viewModel});
  final RoomRequestDetailsViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Room ${viewModel.roomId}'),
        subtitle: Text('Made On:${viewModel.madeOn}'),
        trailing: Text(
            '${viewModel.startingDate} - ${viewModel.endingDate}'),
        // onTap: () => listTileOnTap(request, index, requests),
        onTap: viewModel.cardOnTap,
      ),
    );
  }
}
