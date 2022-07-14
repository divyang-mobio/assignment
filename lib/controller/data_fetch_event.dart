part of 'data_fetch_bloc.dart';

abstract class DataFetchEvent {}

class GetAllData extends DataFetchEvent{
  final String path;

  GetAllData({required this.path});
}