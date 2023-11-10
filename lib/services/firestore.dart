import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task.dart';

class FirestoreService {
  final CollectionReference _tasksCollectionReference =
      FirebaseFirestore.instance.collection('tasks');

  Future<Future<DocumentReference<Object?>>> addTask(Task task) async {
    return _tasksCollectionReference.add(task.toJson());
  }

  Stream<QuerySnapshot> getTasks() {
    final taskStream = _tasksCollectionReference.snapshots();
    // taskStream.listen((event) {
    //   print(event.docs.first.data());
    // });
    return taskStream;
  }

  Future<void> deleteTask(String id) async {
    await _tasksCollectionReference.doc(id).delete();
  }

  // Future<void> updateTask(Task task) async {
  //   await _tasksCollectionReference.doc(task.id).update(task.toJson());
  // }
  Future<void> updateTaskByTitle(String taskTitle, bool isCompleted) async {
    QuerySnapshot querySnapshot = await _tasksCollectionReference
        .where('title', isEqualTo: taskTitle)
        .get();
    // print("querySnapshot.docs : " + querySnapshot.docs.toList().length.toString());
    querySnapshot.docs.forEach((doc) {
      // print("doc : " + doc.data().toString());
      // final bool updatedIsCompleted = !isCompleted; // Inversion de la valeur actuelle
      // doc.reference.update({'isCompleted': updatedIsCompleted});
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      // Update the 'isCompleted' field in the map
      data['isCompleted'] = isCompleted;

      // Update the document in Firestore with the modified data
      _tasksCollectionReference.doc(doc.id).update(data);
    });
  }
}
