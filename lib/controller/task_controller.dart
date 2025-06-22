import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var taskList = <Task>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTasks();
  }

  void fetchTasks() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot = await firestore.collection('tasks').get();
      taskList.value = snapshot.docs.map((doc) => Task.fromDocument(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Could not fetch tasks');
    }
    isLoading.value = false;
  }

  Future<void> addTask(Task task) async {
    try {
      await firestore.collection('tasks').add(task.toMap());
      fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Could not add task');
    }
  }

  Future<void> deleteTask(String id) async {
    try {
      await firestore.collection('tasks').doc(id).delete();
      fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Could not delete task');
    }
  }

  Future<void> updateTaskStatus(String id, String status) async {
    try {
      await firestore.collection('tasks').doc(id).update({'status': status});
      fetchTasks();
    } catch (e) {
      Get.snackbar('Error', 'Could not update task');
    }
  }
}
