import 'package:flutter/material.dart';
import 'package:hotel_management/interface/request.dart';
import 'package:hotel_management/util/date_formatter_util.dart';

class RoomRequestCard extends StatelessWidget {
  const RoomRequestCard({super.key, required this.request, required this.onTap,});
  final RoomRequest request;
  final void Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('Room $roomId',style: const TextStyle(
          fontFamily: 'RobotoCondensed',
          fontWeight: FontWeight.bold,
        ),),
        subtitle: Text('Made On:$madeOn'),
        trailing: Text(
            '$startingDate - $endingDate'),
        // onTap: () => listTileOnTap(request, index, requests),
        onTap: onTap,
      ),
    );
  }
  get roomId => request.roomId;

  get madeOn => DateFormatter.formatWithTime(request.time);

  get startingDate => DateFormatter.format(request.startingDate);

  get endingDate => DateFormatter.format(request.endingDate);
}
