import '../model/data_model.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';
import '../controller/favorite_bloc.dart';
import 'package:badges/badges.dart';
import '../utils/google_ads.dart';
import 'favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/data_fetch_bloc.dart';
import 'listview.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    banner();
    if (_interstitialAd == null) {
      _loadInterstitialAd();
    }
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: GoogleAds.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const FavoriteScreen())),
          );
          setState(() => _interstitialAd = ad);
        },
        onAdFailedToLoad: (LoadAdError error) => print("error"),
      ),
    );
  }

  void banner() {
    BannerAd(
            adUnitId: GoogleAds.bannerAdUnitId,
            listener: BannerAdListener(
              onAdLoaded: (Ad ad) => setState(() => _bannerAd = ad as BannerAd),
            ),
            request: const AdRequest(),
            size: AdSize.banner)
        .load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Assignment with Bloc"),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) => IconButton(
              onPressed: () {
                if (_interstitialAd != null) {
                  _interstitialAd?.show();
                  _interstitialAd == null;
                  _loadInterstitialAd();
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const FavoriteScreen()));
                }
              },
              icon: (state is FavoriteLoaded)
                  ? (state.favoriteData.isNotEmpty)
                      ? Badge(
                          badgeContent: Text("${state.favoriteData.length}"),
                          child: const Icon(Icons.shopping_cart))
                      : const Icon(Icons.shopping_cart)
                  : const Icon(Icons.shopping_cart),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            BlocBuilder<DataFetchBloc, DataFetchState>(
              builder: (_, state) {
                if (state is DataFetchLoading) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: listData([
                      DataModel(
                          brand: "loading",
                          name: "loading",
                          description: "loading")
                    ], false, false, true),
                  );
                } else if (state is DataFetchLoaded) {
                  return listData(state.data, false, false, false);
                } else if (state is DataFetchError) {
                  return const Center(child: Text('error :('));
                } else {
                  return const Center(child: Text("Not Working :("));
                }
              },
            ),
            if (_bannerAd != null)
              Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: _bannerAd?.size.height.toDouble(),
                  width: _bannerAd?.size.width.toDouble(),
                  child: AdWidget(ad: _bannerAd!),
                ),
              )
          ],
        ),
      ),
    );
  }
}
