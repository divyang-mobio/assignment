part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class CheckFavorite extends FavoriteEvent {
  DataModel dataModel;

  CheckFavorite({required this.dataModel});
}

class UpdateData extends FavoriteEvent{
  final String name;

  UpdateData({required this.name});
}

class GetAllDataFavorite extends FavoriteEvent {}
