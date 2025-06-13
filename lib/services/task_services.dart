import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_app_with_firestore/models/task_model.dart';

class TaskServices {
  // reference to the collection
  final CollectionReference _taslCollection =
      FirebaseFirestore.instance.collection('tasks');

  // method to add a task to firestore
  Future<bool> addTask(String taskName) async {
    try {
      // create a new task document with the task name
      final task = TaskModel(
        id: "",
        name: taskName,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isUpdated: false,
      );

      // convert the task to a map
      final Map<String, dynamic> data = task.toJson();

      // add the task to the collection
      final DocumentReference docRef = await _taslCollection.add(data);
      await docRef.update({'id': docRef.id});
      return true;
    } catch (e) {
      print("Error adding task: $e");
      return false;
    }
  }

  // method to get all tasks from firestore
  Stream<List<TaskModel>> getTask() {
    return _taslCollection.snapshots().map(
          (snapshot) => snapshot.docs
              .map(
                (doc) => TaskModel.fromJson(
                  doc.data() as Map<String, dynamic>,
                  doc.id,
                ),
              )
              .toList(),
        );
  }

  // method to update a task by id
  Future<bool> updateTask (TaskModel task) async {
    final Map<String, dynamic> data = task.toJson();

    try {
      await _taslCollection.doc(task.id).update(data);
      return true;
    } catch (error) {
      print("Error updating task: $error");
      return false;
    }
  }

  // delete a task by id
  Future<bool> deleteTask(String id) async {
    try {
      // delete the task document by id
      await _taslCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("Error deleting task: $e");
      return false;
    }
  }
}
