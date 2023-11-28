import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdWidget extends StatefulWidget {
  const BannerAdWidget({super.key, required this.withClose});

  final bool withClose;

  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _closed = false;
  late final double width;
  late final double height;

  @override
  void initState() {
    loadAd();
    if (widget.withClose) {
      width = _bannerAd!.size.width.toDouble();
      height = _bannerAd!.size.height.toDouble();
    } else {
      width = (Get.width) * (3 / 4);
      height = (Get.height) * (1 / 5);
    }
    super.initState();
  }

  final testAdUnitId = 'ca-app-pub-3940256099942544/6300978111';
  final adUnitId = 'ca-app-pub-1457270885871597/8482020472';

  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoaded && !_closed
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: width,
                    height: height,
                    child: AdWidget(ad: _bannerAd!),
                  ),
                  widget.withClose
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              _closed = true;
                            });
                          },
                          icon: const Icon(Icons.close))
                      : const SizedBox()
                ],
              ),
            ),
          )
        : const SizedBox();
  }
}
