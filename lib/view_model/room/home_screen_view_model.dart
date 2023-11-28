import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/interface/room.dart';
import 'package:hotel_management/model/room_model.dart';
import 'package:hotel_management/model/user_model.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:hotel_management/view/room/add_room_view.dart';
import 'package:hotel_management/view/room/room_detail_view.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreenViewModel with ChangeNotifier{

  final RoomModel roomModel = Get.find();
  PanelController panelController = PanelController();
  final InAppReview inAppReview = InAppReview.instance;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  bool isSearching = false;
  var loading = true.obs;
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.example.hotel_management',
    // appStoreIdentifier: '0000000',
  );

  List<Room> get rooms => roomModel.rooms;

  // LoginUser get getUser =>Get.find<SupabaseAuthController>().loginUser;
  void onRoomTap(Room room) {
    Get.to(
      () => RoomDetailsView(
        room: room,
      ),
      duration: const Duration(milliseconds: 500),
      transition: Transition.circularReveal,
      curve: Curves.easeInExpo,
    );
  }

  init() {
    getRoomsBetweenDates();
    rateMyApp.init().then((value) => {
          if (checkOpens())
            {
              inAppReview.isAvailable().then((value) => {
                    if (value)
                      {inAppReview.requestReview()}
                    else
                      {openRateUsStarsDialog()}
                  })
            }
        });
  }

  bool checkOpens() {
    return rateMyApp.shouldOpenDialog;
  }

  openFilters() {
    if (panelController.isPanelOpen) {
      panelController.animatePanelToPosition(0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOutQuart);
    } else {
      panelController.animatePanelToPosition(1,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOutQuart);
    }
  }

  get addRoom =>
      (RoleUtil.fromString(Get.find<UserModel>().role) ==
              ROLE.reception)
          ? FloatingActionButton(
              // title: Text("add".tr),
              onPressed: () {
                Get.to(() => const AddRoom())!.then(
                        (value) => notifyListeners()
                );
              },
              child: const Icon(Icons.add, color: Colors.black),
            )
          : const SizedBox();

  Future<void> getRoomsBetweenDates() async {

    loading.value = true;
    await roomModel.getRoomsBetweenDates(startDate, endDate);
    loading = false.obs;
    notifyListeners();
  }

  getRoomsFiltered(Map<String, dynamic> filters, bool seaView) async {
    filters.forEach((key, value) {
      log('$value', name: key);
    });
    if (isSearching) {
      return;
    }
    loading.value = true;
    int adult = filters['adult'] ?? 0;
    int bed = filters['bed'] ?? 0;
    double max = filters['max'] ?? 10000;
    double min = filters['min'] ?? 0;
    int rating1 = filters['rating1'] ?? 1;
    int rating2 = filters['rating2'] ?? 2;
    int rating3 = filters['rating3'] ?? 3;
    int rating4 = filters['rating4'] ?? 4;
    int rating5 = filters['rating5'] ?? 5;
    isSearching = true;
    await roomModel.getEmptyRoomsFiltered(
      start: startDate,
      end: endDate,
      adult: adult,
      bed: bed,
      max: max,
      min: min,
      rating1: rating1,
      rating2: rating2,
      rating3: rating3,
      rating4: rating4,
      rating5: rating5,
      seaView : seaView,
    );
    loading = false.obs;
    isSearching = false;
    notifyListeners();
  }

  openRateUsDialog() => rateMyApp.showRateDialog(
        Get.context!,
        title: 'Rate this app',
        // The dialog title.
        message: rateUsMessage,
        rateButton: 'RATE',
        noButton: 'NO THANKS',
        laterButton: 'MAYBE LATER',
        ignoreNativeDialog: Platform.isAndroid,
        // ignoreNativeDialog: false,
        dialogStyle: const DialogStyle(),
        onDismissed: () =>
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        contentBuilder: (context, defaultContent) => defaultContent,
        actionsBuilder: (context) => [
          OutlinedButton(
            child: const Text('Never'),
            onPressed: () async {
              if (kDebugMode) {
                print('D:<');
              }
              await rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
              if (context.mounted) {
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
              }
            },
          ),
          OutlinedButton(
            child: const Text('Maybe Later'),
            onPressed: () async {
              if (kDebugMode) {
                print(':( ');
              }
              await rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed);
              if (context.mounted) {
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
              }
            },
          ),
          OutlinedButton(
            child: const Text('OK'),
            onPressed: () async {
              if (kDebugMode) {
                print('Thanks for the Rating !');
              }
              await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
              if (context.mounted) {
                Navigator.pop<RateMyAppDialogButton>(
                    context, RateMyAppDialogButton.rate);
              }
            },
          ),
        ],
      );

  openRateUsStarsDialog() => rateMyApp.showStarRateDialog(
        Get.context!,
        title: 'Rate this app',
        // The dialog title.
        message:
            'You like this app ? Then take a little bit of your time to leave a rating :',
        contentBuilder: (context, defaultContent) => defaultContent,
        actionsBuilder: (context, stars) {
          if (kDebugMode) {
            print(stars ?? 0);
          }
          return [
            OutlinedButton(
              child: const Text('Exit'),
              onPressed: () async {
                await rateMyApp.callEvent(RateMyAppEventType.noButtonPressed);
                if (context.mounted) {
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                }
              },
            ),
            OutlinedButton(
              child: const Text('OK'),
              onPressed: () async {
                if (kDebugMode) {
                  print(
                      'Thanks for the ${stars == null ? '0' : stars.round().toString()} star(s) !');
                }
                //  You can handle the result as you want
                //  (for instance if the user puts 1 star then open your contact page,
                //  if he puts more then open the store page, etc...).
                //  This allows to mimic the behavior of the default "Rate" button.
                //  See "Advanced > Broadcasting events" for more information :
                await rateMyApp.callEvent(RateMyAppEventType.rateButtonPressed);
                if (context.mounted) {
                  Navigator.pop<RateMyAppDialogButton>(
                      context, RateMyAppDialogButton.rate);
                }
              },
            ),
          ];
        },
        ignoreNativeDialog: Platform.isAndroid,
        dialogStyle: const DialogStyle(
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20),
        ),
        starRatingOptions: StarRatingOptions(
          initialRating: 3.5,
          allowHalfRating: true,
          itemColor: Theme.of(Get.context!).primaryColor,
        ),
        onDismissed: () =>
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
      );
}
