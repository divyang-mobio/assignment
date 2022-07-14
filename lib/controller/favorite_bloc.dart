import '../utils/database.dart';
import 'package:bloc/bloc.dart';
import '../model/data_model.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteLoading()) {
    // on<AddDataFavorite>(_onAddFavorite);
    // on<DeleteFavorite>(_onDeleteFavorite);
    on<CheckFavorite>(_onCheckFavorite);
    on<GetAllDataFavorite>(_onGetAllFavorite);
  }

  // void _onAddFavorite(
  //     AddDataFavorite event, Emitter<FavoriteState> emit) async {
  //   await DatabaseHelper.instance.add(event.dataModel);
  //   emit(await _allFavorite());
  // }
  // void _onDeleteFavorite(
  //     DeleteFavorite event, Emitter<FavoriteState> emit) async {
  //   await DatabaseHelper.instance.delete(event.id);
  //   emit(await _allFavorite());
  // }

  void _onCheckFavorite(
      CheckFavorite event, Emitter<FavoriteState> emit) async {
    DatabaseHelper db = DatabaseHelper.instance;
    try {
      final check = await db.checkData(event.dataModel.name);
      (check == null)
          ? await db.add(event.dataModel)
          : await db.delete(check.id as int);
      emit(await _allFavorite());
    } catch (e) {
      emit(FavoriteError());
    }
  }

  void _onGetAllFavorite(
      GetAllDataFavorite event, Emitter<FavoriteState> emit) async {
    try {
      emit(await _allFavorite());
    } catch (e) {
      emit(FavoriteError());
    }
  }

  Future<FavoriteLoaded> _allFavorite() async {
    return FavoriteLoaded(
        favoriteData: await DatabaseHelper.instance.allData());
  }
}
