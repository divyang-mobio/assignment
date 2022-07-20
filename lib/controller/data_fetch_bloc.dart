import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import '../model/data_model.dart';

part 'data_fetch_event.dart';

part 'data_fetch_state.dart';

class DataFetchBloc extends Bloc<DataFetchEvent, DataFetchState> {
  DataFetchBloc() : super(DataFetchLoading()) {
    on<GetAllData>(_getAllData);
  }

  void _getAllData(GetAllData event, Emitter emit) async {
    try {
      String dataParse = await rootBundle.loadString(event.path);
      List dataList = await json.decode(dataParse);
      List<DataModel> data =
          dataList.map((e) => DataModel.fromJson(e)).toList();
      emit(DataFetchLoaded(data: data));
    } catch (e) {
      emit(DataFetchError(errorString: e.toString()));
    }
  }
}
