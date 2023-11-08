import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/pages/component/requests_list_view.dart';
import 'package:hotel_management/util/util_classes.dart';

class ReceptionHome extends StatefulWidget {
  const ReceptionHome({super.key});

  @override
  State<ReceptionHome> createState() => _ReceptionHomeState();
}

class _ReceptionHomeState extends State<ReceptionHome>
    with TickerProviderStateMixin {
  bool pending = false;
  bool approved = false;
  bool intertwined = false;
  bool denied = false;
  late TabController _tabController;
  final UtilityClass util = Get.find();

  @override
  void initState() {
    super.initState();
    util.getUserData();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Requests'),
          bottom: getTabBar(),
        ),
        body: RequestsListView(
          pending: pending,
          approved: approved,
          intertwined: intertwined,
          denied: denied,
        ),
        drawer: util.getDrawer(),
      ),
    );
  }

  getTabBar() => TabBar(
        controller: _tabController,
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
            text: 'intertwined',
          ),
          Tab(
            icon: Icon(Icons.close),
            text: 'Denied',
          ),
        ],
        onTap: _onTapItem,
      );

  _onTapItem(int index) => setState(() {
        if (index == 0) {
          pending = false;
          approved = false;
          intertwined = false;
          denied = false;
        }
        if (index == 1) {
          pending = true;
          approved = false;
          intertwined = false;
          denied = false;
        }
        if (index == 2) {
          pending = false;
          approved = true;
          intertwined = false;
          denied = false;
        }
        if (index == 3) {
          pending = false;
          approved = false;
          intertwined = true;
          denied = false;
        }
        if (index == 4) {
          pending = false;
          approved = false;
          intertwined = false;
          denied = true;
        }
      });
}
