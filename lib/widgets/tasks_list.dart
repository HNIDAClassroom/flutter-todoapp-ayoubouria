import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/services/firestore.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/task_item.dart';
import 'package:intl/intl.dart';
// import 'package:todolist_app/Widgets/task_item.dart';
// import 'package:todolist_app/models/task.dart';
// import 'package:todolist_app/services/firestore.dart';

class TasksList extends StatelessWidget {
  final FirestoreService firestoreService = FirestoreService();

  TasksList({super.key, required this.tasks});

  final List<Task> tasks;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: firestoreService.getTasks(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final taskLists = snapshot.data!.docs;
          List<Task> taskItems = [];
          // print("taskLists : " + taskLists.first.data().toString());

          for (int index = 0; index < taskLists.length; index++) {
            DocumentSnapshot document = taskLists[index];
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            print("data : " + data['title']);
            String title = data['title'] ?? ''; // Handle potential null value
            String description =
                data['description'] ?? ''; // Handle potential null value
            DateTime date;
            if (data['date'] != null) {
              date = DateTime.parse(data['date']);
              
            } else {
              date = DateTime
                  .now(); // Utilisez la date actuelle comme valeur par défaut
            } // Handle potential null value

            String categoryString =
                data['category'] ?? 'others'; // Handle potential null value

            Category category;
            switch (categoryString) {
              case 'personal':
                category = Category.personal;
                break;
              case 'work':
                category = Category.work;
                break;
              case 'shopping':
                category = Category.shopping;
                break;
              default:
                category = Category.other;
            }
            String isCompletedString =
                data['isCompleted'].toString() ?? 'false'; // Handle potential null value
            Task task = Task(
              title: title,
              description: description,
              date: date,
              category: category,
              isCompleted: isCompletedString == 'true',
            );
            taskItems.add(task);
          }
          // print("title : " + taskItems[0].toJson().toString());
          return Expanded(
            child: ListView.builder(
              itemCount: taskItems.length,
              itemBuilder: (ctx, index) {
                return TaskItem(taskItems[index]);
              },
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return CircularProgressIndicator(); // Display a loading indicator while waiting for data.
        }
      },
    );
  }
}
