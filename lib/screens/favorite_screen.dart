import '../controller/favorite_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'listview.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
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
