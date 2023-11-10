import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/firestore.dart';
// import 'package:todolist_app/models/task.dart';
// import 'package:todolist_app/services/firestore.dart';

class TaskItem extends StatelessWidget {
  const TaskItem(this.task, {super.key});
  final Task task;
  
  @override
  Widget build(BuildContext context) {
    final FirestoreService firestoreService = FirestoreService();
    print("task : " + task.isCompleted.toString());
    String formattedDate = DateFormat('yyyy-MM-dd').format(task.date);
    return Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                  Checkbox(
                    value: task.isCompleted,
                    onChanged: (bool? newValue) {
                      if (newValue != null) {
                        print("newValue : " + newValue.toString() + " task.title : " + task.title);
                        firestoreService.updateTaskByTitle(task.title, newValue);
                      }
                    },
                    activeColor: Colors.grey, // Couleur de la case cochée
                    checkColor: Colors.white, // Couleur de la coche
                  ),


                    // const Icon(Icons.task),
                    const SizedBox(width: 10),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(task.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text(task.description),
                      ],
                    )),
                    const SizedBox(width: 140),
                    Flexible(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Date: ${formattedDate}',
                          textAlign: TextAlign.left,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Category: ${task.category.name}',
                          textAlign: TextAlign.left,
                        ),
                      ],
                    )),
                    const SizedBox(width: 20),
                    // IconButton(
                    //   icon: Icon(Icons.delete),
                    //   color: Colors.red,
                    //   onPressed: () {
                    //     firestoreService.deleteTask(task);
                    //   },
                    // ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirmez la suppression"),
                              content: Text(
                                  "Êtes-vous sûr de vouloir supprimer cette tâche ?"),
                              actions: <Widget>[
                                TextButton(
                                  child: Text("Oui"),
                                  onPressed: () {
                                    // Supprimez la tâche ici
                                    firestoreService.deleteTask(task.title);
                                    Navigator.of(context)
                                        .pop(); // Ferme la boîte de dialogue
                                  },
                                ),
                                TextButton(
                                  child: Text("Non"),
                                  onPressed: () {
                                    Navigator.of(context)
                                        .pop(); // Ferme la boîte de dialogue
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      },
                    )
                  ],
                )
              ],
            )));
  }
}
