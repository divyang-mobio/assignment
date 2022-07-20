part of 'favorite_bloc.dart';

abstract class FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  List<DataModel> favoriteData, fireStoreData;

  FavoriteLoaded({required this.favoriteData, required this.fireStoreData});
}

class FavoriteError extends FavoriteState {
  String errorString;

  FavoriteError({required this.errorString});
}
