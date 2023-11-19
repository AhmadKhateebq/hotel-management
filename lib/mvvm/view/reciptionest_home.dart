import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/view_model/reciptionest_home_view_model.dart';
import 'package:provider/provider.dart';

import 'components/flow/floating_action_button_flow.dart';

class ReceptionHome extends StatefulWidget {
  const ReceptionHome({super.key});

  @override
  State<ReceptionHome> createState() => _ReceptionHomeState();
}

class _ReceptionHomeState extends State<ReceptionHome>
    with TickerProviderStateMixin {
  late final ReceptionHomeViewModel viewModel;

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
          body: getBody(),
          drawer: viewModel.getDrawer(),
          floatingActionButton: FloatingActionButtonFlow(
            icons:viewModel.icons,
            functions: viewModel.functions,
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ),
      ),
    );
  }

  getTabBar(context) => TabBar(
        controller: Provider.of<ReceptionHomeViewModel>(context).tabController,
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
        onTap: Provider.of<ReceptionHomeViewModel>(context).onTapItem,
      );

  getBody() => PageView(
        controller: viewModel.controller,
        onPageChanged: viewModel.onPageChange,
        children: viewModel.requests,
      );
}
