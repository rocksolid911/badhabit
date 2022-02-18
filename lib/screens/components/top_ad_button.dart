import 'dart:async';

import 'package:badhabit/helpers/ad_helper.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sizer/sizer.dart';

class TopAdButton extends StatefulWidget {
  const TopAdButton({Key? key}) : super(key: key);

  @override
  _TopAdButtonState createState() => _TopAdButtonState();
}

class _TopAdButtonState extends State<TopAdButton> {
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdLoaded = false;

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

    _loadInterstitial();
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
        if (_isInterstitialAdLoaded == false) {
          _loadAttempts = 0;
          _loadInterstitial();
        }
        break;
      default:
        break;
    }
  }

  void _loadInterstitial() {
    InterstitialAd.load(
      adUnitId: AdHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _loadAttempts = 0;
          _isInterstitialAdLoaded = true;
        },
        onAdFailedToLoad: (LoadAdError error) async {
          await Future.delayed(const Duration(milliseconds: 500));

          _loadAttempts++;
          _interstitialAd = null;
          if (_loadAttempts <= _maxFailedLoadAttempts) {
            _loadInterstitial();
          } else if (error.code == 3 &&
              _loadAttempts <= _maxFailedLoadAttempts2) {
            await Future.delayed(const Duration(milliseconds: 500));
            _loadInterstitial();
          } else if (error.code == 3 &&
              _loadAttempts <= _maxFailedLoadAttemptsCode3) {
            await Future.delayed(const Duration(seconds: 4));
            _loadInterstitial();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    _interstitialAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);

          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild?.unfocus();
          }
        },
        child: GestureDetector(
          onTap: () => {
            if (_isInterstitialAdLoaded)
              {_interstitialAd?.show(), _loadInterstitial()}
          },
          child: SvgPicture.asset(
            "assets/images/advertising.svg",
            color: Colors.white.withOpacity(0.9),
            width: SizerUtil.deviceType == DeviceType.mobile ? 5.5.w : 3.5.w,
          ),
        ),
      ),
    );
  }
}
