import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/request.dart';
import 'package:hotel_management/mvvm/view/requests/requests_list_page.dart';
import 'package:hotel_management/mvvm/view_model/reciptionest_home_view_model.dart';
import 'package:hotel_management/mvvm/view_model/request/request_list_view_model.dart';
import 'package:provider/provider.dart';

class ReceptionHome extends StatefulWidget {
  const ReceptionHome({super.key});

  @override
  State<ReceptionHome> createState() => _ReceptionHomeState();
}

class _ReceptionHomeState extends State<ReceptionHome>
    with TickerProviderStateMixin {
  late final ReceptionHomeViewModel viewModel;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ReceptionHomeViewModel>(
      create: (_) {
        viewModel = ReceptionHomeViewModel();
        viewModel.init(this);
        return viewModel;
      },
      builder: (context, child) => SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Requests'),
            bottom: getTabBar(context),
          ),
          body: RequestsList(
            viewModel: RequestsListViewModel(
              pending: viewModel.pending,
              approved: viewModel.approved,
              intertwined: viewModel.intertwined,
              denied: viewModel.denied,
              dataStream: viewModel.getRequestsStream(),
              mapper: RoomRequest.fromDynamicMap,
            ),
          ),
          drawer: viewModel.getDrawer(),
        ),
      ),
    );
  }

  getTabBar(context) => TabBar(
        controller: Provider.of<ReceptionHomeViewModel>(context).tabController,
        // isScrollable: true,
        // labelPadding:  EdgeInsets.symmetric(horizontal: Get.width/15),
        labelPadding:  const EdgeInsets.symmetric(horizontal: 0),
        unselectedLabelStyle: const TextStyle(
            // fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
            fontFamily: 'RobotoCondensed'
        ),
        labelStyle: const TextStyle(
          // fontWeight: FontWeight.bold,
          // fontStyle: FontStyle.italic,
          fontFamily: 'Lobster'
        ),
        tabs: const <Tab>[
          Tab(
            icon: Icon(Icons.home),
            text: 'All',
          ),
          Tab(
            icon: Icon(Icons.access_time_outlined),
            text: 'Pending',
          ),
          Tab(
            icon: Icon(Icons.check),
            text: 'Approved',
          ),
          Tab(
            icon: Icon(Icons.compare_arrows),
            text: 'Overlap',
          ),
          Tab(
            icon: Icon(Icons.close),
            text: 'Denied',
          ),
        ],
        onTap: Provider.of<ReceptionHomeViewModel>(context).onTapItem,
      );
}
