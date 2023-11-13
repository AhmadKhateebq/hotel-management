import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/mvvm/view/filters_menu.dart';
import 'package:hotel_management/mvvm/view/room/rooms_list_view.dart';
import 'package:hotel_management/mvvm/view_model/filters_menu_model_view.dart';
import 'package:hotel_management/mvvm/view_model/home_screen_view_model.dart';
import 'package:hotel_management/mvvm/view_model/room/room_list_view_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeScreenViewModel viewModel = HomeScreenViewModel();

  @override
  void initState() {
    viewModel.getUserData();
    viewModel.init();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    viewModel.getRooms();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: homeScreen(),
          appBar: AppBar(
            title: const Text(
              'Available Rooms',
              style: TextStyle(fontSize: 24),
            ),
            titleSpacing: 0,
            centerTitle: true,
            actions: [
              IconButton(
                  onPressed: viewModel.openFilters,
                  icon: const Icon(Icons.filter_alt)),
            ],
          ),
          drawer: viewModel.getDrawer,
          floatingActionButton: viewModel.addRoom),
    );
  }

  homeScreen() => Stack(children: [
        Center(
            child: Obx(
          () => viewModel.loading.value
              ? const CircularProgressIndicator()
              : Obx(
                  () => RoomsListView(
                      viewModel: RoomListViewModel(
                    startDate: viewModel.startDate,
                    endDate: viewModel.endDate,
                    rooms: viewModel.rooms.value,
                  )),
                ),
        )),
        SlidingUpPanel(
          controller: viewModel.panelController,
          panel: FiltersCustomMenu(
            viewModel: FilterMenuModelView(
                panelController: viewModel.panelController,
                search: viewModel.getRoomsFiltered),
          ),
          maxHeight: Get.height,
          minHeight: 0,
        ),
      ]);
}
