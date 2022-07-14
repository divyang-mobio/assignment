part of 'favorite_bloc.dart';

abstract class FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  List<DataModel> favoriteData;

  FavoriteLoaded({required this.favoriteData});
}

class FavoriteError extends FavoriteState {}