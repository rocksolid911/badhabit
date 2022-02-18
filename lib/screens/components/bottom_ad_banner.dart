import 'dart:async';

import 'package:badhabit/helpers/ad_helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

enum Screen { list, edit, details }

class BottomAdBanner extends StatefulWidget {
  final Screen screen;
  final int screenWidth;

  const BottomAdBanner(
      {Key? key, required this.screen, required this.screenWidth})
      : super(key: key);

  @override
  _BottomAdBannerState createState() => _BottomAdBannerState();
}

class _BottomAdBannerState extends State<BottomAdBanner> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;
  AdSize? _size;

  final int _maxFailedLoadAttempts = 5;
  final int _maxFailedLoadAttempts2 = 10;
  final int _maxFailedLoadAttemptsCode3 = 15;
  int _loadAttempts = 0;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _loadBanner();
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initConnectivity() async {
    ConnectivityResult result = ConnectivityResult.none;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
        if (_isBannerAdLoaded == false) {
          _loadAttempts = 0;
          _loadBanner();
        }
        break;
      default:
        break;
    }
  }

  void _loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: SizerUtil.deviceType == DeviceType.mobile
          ? AdSize.getInlineAdaptiveBannerAdSize(
              widget.screenWidth,
              60,
            )
          : AdSize.fullBanner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) async {
          try {
            _size = await _bannerAd?.getPlatformAdSize();
          } catch (e) {
            debugPrint(e.toString());
          } finally {
            _loadAttempts = 0;

            if (mounted) {
              setState(() {
                _isBannerAdLoaded = true;
              });
            }
          }
        },
        onAdFailedToLoad: (ad, error) async {
          ad.dispose();

          await Future.delayed(const Duration(milliseconds: 500));

          _loadAttempts++;
          if (_loadAttempts <= _maxFailedLoadAttempts) {
            _loadBanner();
          } else if (error.code == 3 &&
              _loadAttempts <= _maxFailedLoadAttempts2) {
            await Future.delayed(const Duration(milliseconds: 500));
            _loadBanner();
          } else if (error.code == 3 &&
              _loadAttempts <= _maxFailedLoadAttemptsCode3) {
            await Future.delayed(const Duration(seconds: 4));
            _loadBanner();
          }
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _bannerAd != null && _isBannerAdLoaded == true
        ? SizedBox(
            child: AdWidget(ad: _bannerAd!),
            width: _size == null
                ? _bannerAd!.size.width.toDouble()
                : _size!.width.toDouble(),
            height: _size == null
                ? _bannerAd!.size.height.toDouble()
                : _size!.height.toDouble(),
          )
        : widget.screen == Screen.list || widget.screen == Screen.details
            ? const SizedBox.shrink()
            : const SizedBox(height: 60);
  }
}
