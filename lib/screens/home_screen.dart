import '../controller/favorite_bloc.dart';
import 'package:badges/badges.dart';
import 'favorite_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/data_fetch_bloc.dart';
import 'listview.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Assignment with Bloc"),
        actions: [
          BlocBuilder<FavoriteBloc, FavoriteState>(
            builder: (context, state) => IconButton(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const FavoriteScreen())),
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
      body: BlocBuilder<DataFetchBloc, DataFetchState>(
        builder: (_, state) {
          if (state is DataFetchLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          } else if (state is DataFetchLoaded) {
            return listData(state.data, false);
          } else if (state is DataFetchError) {
            return const Center(child: Text('error :('));
          } else {
            return const Center(child: Text("Not Working :("));
          }
        },
      ),
    );
  }
}
