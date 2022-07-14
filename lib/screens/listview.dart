import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../controller/favorite_bloc.dart';
import '../model/data_model.dart';

listData(List<DataModel> data) {
  return (data.isNotEmpty)
      ? ListView.builder(
          itemCount: data.length,
          itemBuilder: (context, index) => GestureDetector(
            onDoubleTap: () => BlocProvider.of<FavoriteBloc>(context).add(
              CheckFavorite(
                dataModel: DataModel(
                  name: data[index].name,
                  description: data[index].description,
                  brand: data[index].brand,
                ),
              ),
            ),
            child: Card(
              margin: const EdgeInsetsDirectional.all(8),
              elevation: 8,
              child: ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Brand Name: ${data[index].brand}"),
                    const SizedBox(height: 10),
                    Text("Model Name :${data[index].name}"),
                    const SizedBox(height: 10)
                  ],
                ),
                subtitle: Text("Description: ${data[index].description}",
                    maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
            ),
          ),
        )
      : const Center(child: Text('No Data in Cart'));
}
