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
            child: CardData(data: data[index]),
          ),
        )
      : const Center(child: Text('No Data in Cart'));
}

class CardData extends StatefulWidget {
  const CardData({Key? key, required this.data}) : super(key: key);
  final DataModel data;

  @override
  State<CardData> createState() => _CardDataState();
}

class _CardDataState extends State<CardData> {
  bool showMoreData = false;

  void showMore() {
    setState(() => showMoreData = !showMoreData);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsetsDirectional.all(8),
      elevation: 8,
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Company Name: ${widget.data.brand}"),
            const SizedBox(height: 10),
            Text("Model No:${widget.data.name}"),
            const SizedBox(height: 10)
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Description: ${widget.data.description}",
                maxLines: (showMoreData) ? 100 : 2,
                overflow: TextOverflow.ellipsis),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => showMore(),
                    child: (showMoreData)
                        ? const Text("show less")
                        : const Text("show More")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
