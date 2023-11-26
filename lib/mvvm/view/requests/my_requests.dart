import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view_model/request/my_request_view_model.dart';
import 'package:provider/provider.dart';

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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MyRequestsViewModel>(
      create: (_) {
        viewModel = MyRequestsViewModel();
        viewModel.init(this);
        return viewModel;
      },
      builder: (context, child) => SafeArea(
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
        ),
      ),
    );
  }

  getTabBar(context) => TabBar(
    controller: Provider.of<MyRequestsViewModel>(context).tabController,
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
    onTap: Provider.of<MyRequestsViewModel>(context).onTapItem,
  );
}
