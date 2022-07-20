part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class CheckFavorite extends FavoriteEvent {
  DataModel dataModel;

  CheckFavorite({required this.dataModel});
}

class GetAllDataFavorite extends FavoriteEvent {}
