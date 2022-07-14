part of 'favorite_bloc.dart';

abstract class FavoriteEvent {}

class CheckFavorite extends FavoriteEvent {
  DataModel dataModel;

  CheckFavorite({required this.dataModel});
}

class GetAllDataFavorite extends FavoriteEvent {}
// class AddDataFavorite extends FavoriteEvent {
//   DataModel dataModel;
//
//   AddDataFavorite({required this.dataModel});
// }
//
// class DeleteFavorite extends FavoriteEvent {
//   int id;
//
//   DeleteFavorite({required this.id});
// }
