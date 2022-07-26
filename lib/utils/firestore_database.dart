import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/data_model.dart';

class FirebaseDatabase {
  DocumentSnapshot? paginationData;
  List<DataModel> allData = [];
  bool isMore = true;
  final instance = FirebaseFirestore.instance.collection("FAVOURITE");

  // var batch = FirebaseFirestore.instance.batch();

  void addDataFirebase(DataModel dataModel) async {
    await instance.doc(dataModel.name).set(dataModel.toJson());

    /// Batch
    // batch.set(instance.doc(dataModel.name), {"name": "Divyang"});
    // batch.update(instance.doc(dataModel.name), {"name" : "Divyang INC"});
    // batch.commit().then((value) {
    //   batch = FirebaseFirestore.instance.batch();
    // });
  }

  void deleteDataFirebase(String name) async =>
      await instance.doc(name).delete();

  Future<void> updateDataFirebase(String name) async {
    await instance.doc(name).update({'id': 1});
    /// Transaction
    // FirebaseFirestore.instance.runTransaction((transaction) async {
    //   DocumentSnapshot documentSnapshot =
    //       await transaction.get(instance.doc(name));
    //   transaction.update(instance.doc(name),
    //       {"id": documentSnapshot.get('id') + 1, "name": "Divyang INC"});
    // });
  }

  Future<List<DataModel>> allDataFirebase() async {
    var rData = instance.limit(2);
    // .where("name", isEqualTo: "Note 4")
    if (isMore) {
      var rawData = (paginationData?.data() == null)
          ? await rData.get().then((value) {
              if (value.docChanges.isEmpty) {
                isMore = false;
              } else {
                paginationData = value.docChanges.last.doc;
                return value.docChanges.map((e) => e.doc.data());
              }
            })
          : await rData.startAfterDocument(paginationData!).get().then((value) {
              if (value.docChanges.isEmpty) {
                isMore = false;
              } else {
                paginationData = value.docChanges.last.doc;
                return value.docChanges.map((e) => e.doc.data());
              }
            });

      if (isMore) {
        List<DataModel>? data = rawData
            ?.map((e) => DataModel.fromJson(e as Map<String, dynamic>))
            .toList();
        if (data?.length != 2) {
          isMore = false;
        }
        allData.addAll(data ?? []);
      }
    }
    return allData;
  }
}
