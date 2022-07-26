import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'screens/login_screen.dart';
import 'utils/firestore_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'controller/favorite_bloc.dart';
import 'controller/data_fetch_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<FirebaseDatabase>(
      create: (context) => FirebaseDatabase(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DataFetchBloc>(create: (context) => DataFetchBloc()),
          BlocProvider<FavoriteBloc>(
              create: (context) => FavoriteBloc(
                  RepositoryProvider.of<FirebaseDatabase>(context))),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Assignment',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
