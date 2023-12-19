import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/room/room_card.dart';
import 'package:hotel_management/view_model/room/my_rooms_view_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class MyRoomsView extends StatefulWidget {
  const MyRoomsView({super.key});

  @override
  State<MyRoomsView> createState() => _MyRoomsViewState();
}

class _MyRoomsViewState extends State<MyRoomsView> {
  final MyRoomsViewModel viewModel = MyRoomsViewModel();

  @override
  void initState() {
    viewModel.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Rooms"),
      ),
      body: Obx(() => viewModel.loading.value ? loading : mainWidget),
    );
  }

  get loading => const Center(
        child: CircularProgressIndicator(),
      );
  get mainWidget => Obx(
        () => viewModel.empty.value
        ? empty
        : Stack(
      children: [
        listView,
        panel,
      ],
    ),
  );
  get empty => SizedBox.expand(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'You Have No Rooms yet :(',
          style: style,
        ),
        TextButton(
            onPressed: viewModel.reserveNow,
            child: Text(
              'Reserve Now !',
              style: style,
            )),
      ],
    ),
  );

  TextStyle get style => const TextStyle(
    fontSize: 24,
  );

  get listView => ListView.builder(
      itemCount: viewModel.rooms.length,
      itemBuilder: (context, index) => InkWell(
          onTap: () => viewModel.onTap(index),
          child: RoomCard(room: viewModel.rooms[index],)));


  get panel => SlidingUpPanel(
    minHeight: 0,
    maxHeight: Get.height *.19,
    controller: viewModel.panelController,
    panelBuilder: (c) => panelBody,
  );
  get panelBody => Column(
    children: [
      const Center(
        child: Text(
          'Rate This Room',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
      ),
      Obx(() => Text(viewModel.currentRoom.value.roomId)),
      ratingWidget,
      FilledButton(
          onPressed: viewModel.submit, child: const Text('Submit Review'))
    ],
  );

  get ratingWidget => Obx(
        () => RatingBar.builder(
          initialRating: viewModel.currentRoom.value.stars,
          minRating: 1,
          maxRating: 5,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: viewModel.setStars,
        ),
      );

}
