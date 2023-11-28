import 'package:flutter/material.dart';
import 'package:hotel_management/component/animation/flow/floating_action_button_flow.dart';
import 'package:hotel_management/view_model/request/my_request_view_model.dart';

class MyRequests extends StatefulWidget {
  const MyRequests({super.key});

  @override
  State<MyRequests> createState() => _MyRequestsState();
}

class _MyRequestsState extends State<MyRequests>
    with TickerProviderStateMixin {
  late final MyRequestsViewModel viewModel;

  @override
  void initState() {
    viewModel = MyRequestsViewModel();
    viewModel.init(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return
      SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('My Requests'),
            bottom: getTabBar(context),
          ),
          body: PageView(
            controller: viewModel.controller,
            onPageChanged: viewModel.onPageChange,
            children: viewModel.requests,
          ),
          floatingActionButton :FloatingActionButtonFlow(
            icons:viewModel.icons,
            functions: viewModel.functions,
          ),
          floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
        ),
      );

  }

  getTabBar(context) => TabBar(
    controller: viewModel.tabController,
    // isScrollable: true,
    // labelPadding:  EdgeInsets.symmetric(horizontal: Get.width/15),
    labelPadding: const EdgeInsets.symmetric(horizontal: 0),
    unselectedLabelStyle: const TextStyle(
      // fontStyle: FontStyle.italic,
        fontWeight: FontWeight.bold,
        fontFamily: 'RobotoCondensed'),
    labelStyle: const TextStyle(
      // fontWeight: FontWeight.bold,
      // fontStyle: FontStyle.italic,
        fontFamily: 'Lobster'),
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
    onTap: viewModel.onTapItem,
  );
}
