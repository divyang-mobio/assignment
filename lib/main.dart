import 'controller/favorite_bloc.dart';
import 'controller/data_fetch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens/home_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DataFetchBloc>(
            create: (context) =>
                DataFetchBloc()..add(GetAllData(path: "assets/data.json"))),
        BlocProvider<FavoriteBloc>(
            create: (context) => FavoriteBloc()..add(GetAllDataFavorite())),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Assignment',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}
