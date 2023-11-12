import 'package:flutter/material.dart';
import 'package:hotel_management/mvvm/model/request.dart';

class RequestsPageViewModelView {
  final int? initialPage;
  final List<RoomRequest> list;
  final PageController pageController;

  RequestsPageViewModelView({required this.initialPage, required this.list})
      : pageController = PageController(initialPage: initialPage ?? 0);
}
