import 'package:flutter/material.dart';
import 'package:hotel_management/view_model/request/request_page_view_model.dart';

import '../../component/animation/flow/floating_action_button_flow.dart';

class RequestsPagesView extends StatefulWidget {
  const RequestsPagesView({super.key, this.myRequests});
  final bool? myRequests;
  @override
  State<RequestsPagesView> createState() => _RequestsPagesViewState();
}

class _RequestsPagesViewState extends State<RequestsPagesView>
    with TickerProviderStateMixin {
  late final RequestsPageViewModel viewModel;
  @override
  void initState() {
    viewModel = RequestsPageViewModel(myRequests: widget.myRequests);
    viewModel.init(this);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: viewModel.title,
          bottom: getTabBar(context),
        ),
        body: getBody(),
        drawer: viewModel.drawer,
        floatingActionButton: FloatingActionButtonFlow(
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
        labelPadding: const EdgeInsets.symmetric(horizontal: 0),
        unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: 'RobotoCondensed'),
        labelStyle: const TextStyle(
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

  getBody() => PageView(
        controller: viewModel.controller,
        onPageChanged: viewModel.onPageChange,
        children: viewModel.requests,
      );
}
