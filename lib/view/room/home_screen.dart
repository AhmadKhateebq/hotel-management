import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/component/ads/banner_ads.dart';
import 'package:hotel_management/component/custom_drawer.dart';
import 'package:hotel_management/component/room/filters_menu.dart';
import 'package:hotel_management/component/room/room_cards_list.dart';
import 'package:hotel_management/view_model/room/home_screen_view_model.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        key: _key,
        child: ChangeNotifierProvider<HomeScreenViewModel>(create: (context) {
          HomeScreenViewModel viewModel = HomeScreenViewModel();
          viewModel.init();
          return viewModel;
        }, builder: (context, child) {
          final viewModel = Provider.of<HomeScreenViewModel>(context);
          return Scaffold(
            body: Stack(children: [
              Center(
                  child: Obx(
                () => viewModel.loading.value
                    ? const CircularProgressIndicator()
                    : RoomCardList(
                        rooms: viewModel.rooms,
                        onRefresh: viewModel.getRoomsBetweenDates,
                        onTap: viewModel.onRoomTap,
                      ),
              )),
              SlidingUpPanel(
                controller: viewModel.panelController,
                panel: FiltersCustomMenu(
                  panelController: viewModel.panelController,
                  searchOnClick: viewModel.getRoomsFiltered,
                  resetOnClick: viewModel.getRoomsBetweenDates,
                ),
                maxHeight: Get.height,
                minHeight: 0,
              ),
              const BannerAdWidget(withClose: true),
            ]),
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
            drawer: const CustomDrawer(),
            floatingActionButton: viewModel.addRoom
          );
        }));
  }
}
