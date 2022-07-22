import '../utils/google_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../controller/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'listview.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  RewardedAd? _rewardedAd;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadRewardedAd();
  }

  @override
  void dispose() {
    _rewardedAd?.dispose();
    super.dispose();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: GoogleAds.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          print('Failed to load a rewarded ad: ${err.message}');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new),
            onPressed: () {
              _rewardedAd?.show(
                onUserEarnedReward: (_, reward) {
                  Navigator.pop(context);
                },
              );
            },
          ),
          title: const Text("Cart")),
      body: BlocBuilder<FavoriteBloc, FavoriteState>(builder: (_, state) {
        if (state is FavoriteLoading) {
          return const Center(child: CircularProgressIndicator.adaptive());
        } else if (state is FavoriteLoaded) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text("local database data :",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                listData(state.favoriteData, true, true),
                const SizedBox(height: 10),
                const Text("FireStore database data :",
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                listData(state.fireStoreData, false, true)
              ],
            ),
          );
        } else if (state is FavoriteError) {
          return const Center(child: Text('error :('));
        } else {
          return const Center(child: Text("Not Working :("));
        }
      }),
    );
  }
}
