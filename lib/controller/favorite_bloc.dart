import '../utils/database.dart';
import 'package:bloc/bloc.dart';
import '../model/data_model.dart';
import '../utils/firestore_database.dart';

part 'favorite_event.dart';

part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final FirebaseDatabase _firebaseDatabase;

  FavoriteBloc(this._firebaseDatabase) : super(FavoriteLoading()) {
    // on<AddDataFavorite>(_onAddFavorite);
    // on<DeleteFavorite>(_onDeleteFavorite);
    on<CheckFavorite>(_onCheckFavorite);
    on<GetAllDataFavorite>(_onGetAllFavorite);
  }

  void _onCheckFavorite(
      CheckFavorite event, Emitter<FavoriteState> emit) async {
    DatabaseHelper db = DatabaseHelper.instance;
    try {
      final check = await db.checkData(event.dataModel.name);
      (check == null)
          ? {
              await db.add(event.dataModel),
              _firebaseDatabase.addDataFirebase(event.dataModel)
            }
          : {
              await db.delete(check.id as int),
              _firebaseDatabase.deleteDataFirebase(event.dataModel.name)
            };
      emit(await _allFavorite());
    } catch (e) {
      emit(FavoriteError(errorString: e.toString()));
    }
  }

  void _onGetAllFavorite(
      GetAllDataFavorite event, Emitter<FavoriteState> emit) async {
    try {
      emit(await _allFavorite());
    } catch (e) {
      emit(FavoriteError(errorString: e.toString()));
    }
  }

  Future<FavoriteLoaded> _allFavorite() async {
    return FavoriteLoaded(
        favoriteData: await DatabaseHelper.instance.allData(),
        fireStoreData: await _firebaseDatabase.allDataFirebase());
  }
}
