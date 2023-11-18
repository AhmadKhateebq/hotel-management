import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hotel_management/controller/auth_controller.dart';
import 'package:hotel_management/mvvm/model/room.dart';
import 'package:hotel_management/mvvm/repository/room/room_api.dart';
import 'package:hotel_management/util/const.dart';
import 'package:hotel_management/util/util_classes.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomeScreenViewModel {
  PanelController panelController = PanelController();
  TextEditingController adultController = TextEditingController();
  TextEditingController bedsController = TextEditingController();
  final InAppReview inAppReview = InAppReview.instance;
  double maxPriceCanChoose = 1000;
  double minPriceCanChoose = 0;
  late RangeValues priceRange;
  double rating = 0;
  int adults = 2;
  int beds = 1;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));
  List<bool> stars = [true, true, true, true, true];
  bool seaView = false;
  var rooms = <Room>[].obs;
  bool isSearching = false;
  var loading = true.obs;
  var isFilterShowing = false.obs;
  RateMyApp rateMyApp = RateMyApp(
    preferencesPrefix: 'rateMyApp_',
    minDays: 7,
    minLaunches: 10,
    remindDays: 7,
    remindLaunches: 10,
    googlePlayIdentifier: 'com.example.hotel_management',
    // appStoreIdentifier: '0000000',
  );

  void init() {
    bedsController.text = '$beds';
    adultController.text = '$adults';
    priceRange = RangeValues(minPriceCanChoose, maxPriceCanChoose);
    getRooms().then((_) async {
      if (checkOpens()) {
        if (await inAppReview.isAvailable()) {
          inAppReview.requestReview();
        }
      }

      await rateMyApp.init();
      openRateUsStarsDialog();
      try {
        rateMyApp.launchNativeReviewDialog();
      } catch (e) {
        print(e);
      }
      // openRateUsDialog();
      if (Get.context!.mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(Get.context!);
      }
    });
  }

  bool checkOpens() {
    return true;
  }

  void getUserData() {
    Get.find<SupabaseAuthController>().getUserData();
  }

  openFilters() {
    panelController.isPanelOpen
        ? panelController.close()
        : panelController.open();
    isFilterShowing.value = !isFilterShowing.value;
  }

  get getDrawer => Get.find<SupabaseAuthController>().loginUser.getDrawer();

  get addRoom =>
      (Get.find<SupabaseAuthController>().loginUser.role == ROLE.admin)
          ? FloatingActionButton(
              // title: Text("add".tr),
              onPressed: () {
                Get.offAllNamed('/add_room');
              },
              child: const Icon(Icons.add, color: Colors.black),
            )
          : const SizedBox();

  Future<void> getRooms() async {
    isFilterShowing.value = false;
    loading.value = true;
    rooms.value = await RoomApi().getEmptyRooms(
      start: startDate,
      end: endDate,
    );
    await Future.delayed(const Duration(milliseconds: 250));
    loading.value = false;
  }

  getRoomsFiltered(Map<String, dynamic> filters, bool seaView) async {
    filters.forEach((key, value) {
      log('$value', name: key);
    });
    if (isSearching) {
      return;
    }
    loading.value = true;
    isFilterShowing.value = false;
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
    rooms.value = await RoomApi().getEmptyRoomsFiltered(
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
    );
    if (seaView) {
      rooms.value = rooms.where((room) => room.seaView).toList();
    }
    loading.value = false;
    isSearching = false;
  }

  openRateUsDialog() => rateMyApp.showRateDialog(
        Get.context!,
        title: 'Rate this app',
        // The dialog title.
        message: rateUsMessage,
        rateButton: 'RATE',
        noButton: 'NO THANKS',
        laterButton: 'MAYBE LATER',
        //uses the native rating app, ass google play store or app store
        // listener: (button) {
        //   switch (button) {
        //     case RateMyAppDialogButton.rate:
        //       if (kDebugMode) {
        //         print('Clicked on "Rate".');
        //       }
        //       break;
        //     case RateMyAppDialogButton.later:
        //       if (kDebugMode) {
        //         print('Clicked on "Later".');
        //       }
        //       break;
        //     case RateMyAppDialogButton.no:
        //       if (kDebugMode) {
        //         print('Clicked on "No".');
        //       }
        //       break;
        //   }
        //
        //   return true; // Return false if you want to cancel the click event.
        // },
        ignoreNativeDialog: Platform.isAndroid,
        // ignoreNativeDialog: false,
        // Set to false if you want to show the Apple's native app rating dialog on iOS or Google's native app rating dialog (depends on the current Platform).
        dialogStyle: const DialogStyle(),
        onDismissed: () =>
            rateMyApp.callEvent(RateMyAppEventType.laterButtonPressed),
        // Called when the user dismissed the dialog (either by taping outside or by pressing the "back" button).
        contentBuilder: (context, defaultContent) => defaultContent,
        // This one allows you to change the default dialog content.
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
