import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/data_model.dart';

class FirebaseDatabase {
  final instance = FirebaseFirestore.instance.collection("FAVOURITE");

  void addDataFirebase(DataModel dataModel) async {
    await instance
        .doc(dataModel.name)
        .set(dataModel.toJson());
  }

  void deleteDataFirebase(String name) async {
    await instance.doc(name).delete();
  }

  Future<List<DataModel>> allDataFirebase() async {
    var rawData = await instance
        .get()
        .then((value) => value.docChanges.map((e) => e.doc.data()));

    List<DataModel> data = rawData
        .map((e) => DataModel.fromJson(e as Map<String, dynamic>))
        .toList();

    return data;
  }
}
