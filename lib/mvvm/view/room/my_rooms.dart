import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view/room/room_card.dart';
import 'package:hotel_management/mvvm/view_model/room/my_rooms_view_model.dart';
import 'package:hotel_management/mvvm/view_model/room/room_card_view_model.dart';
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
      body: Obx(() => viewModel.loading.value ? loadingScreen : homeScreen),
    );
  }

  get loadingScreen => const Center(
        child: CircularProgressIndicator(),
      );

  get listView => ListView.builder(
      itemCount: viewModel.rooms.length,
      itemBuilder: (contxt, index) => InkWell(
          onTap: () => viewModel.onTap(index),
          child: RoomCard(
              viewModel: RoomCardViewModel(
                  room: viewModel.rooms[index], isHistory: true))));

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
      Obx(()=>Text(viewModel.currentRoom.value.roomId)),
      getRatingWidget(),
      FilledButton(onPressed: viewModel.submit, child: const Text('Submit Review'))
    ],
  );

  get homeScreen => Obx(
    ()=>viewModel.empty.value? SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Text(
            'You Have No Rooms yet :(',style: style,
          ),
          TextButton(onPressed: viewModel.reserveNow, child:  Text('Reserve Now !',style: style,)),
        ],
      ),
    ): Stack(
          children: [
            listView,
            panel,
          ],
        ),
  );

  getRatingWidget() => Obx(
    ()=> RatingBar.builder(
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
          onRatingUpdate:viewModel.setStars,
        ),
  );
  TextStyle get style => const TextStyle(
    fontSize: 24,
  );
}
