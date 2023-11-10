import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/widgets/new_task.dart';
import 'package:todo_app/widgets/tasks_list.dart';
import 'package:todo_app/screens/auth_gate.dart';
import 'package:todo_app/widgets/task_item.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);
  

  void addTask(Task task) {
    print(task.toJson());
  }

  void _openAddTaskOverlay(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => NewTask(addTask), // Pass a function to add tasks
    );
  }

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    // ignore: use_build_context_synchronously
    await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AuthGate(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Task> registeredTasks;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          // leading: IconButton(onPressed: () {
          //   Scaffold.of(context).openDrawer();

          // }, icon: const Icon(Icons.menu)),
          title: Image.asset("assets/images/logo.png", height: 35),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     icon: const Icon(Icons.bed),
          //     onPressed: () {},
          //   ),
          // ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.home),
                title: Text("Home"),
              ),
              const ListTile(
                leading: Icon(Icons.settings),
                title: Text("Settings"),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Logout"),
                onTap: () {
                  FutureBuilder(
                    future: Future.delayed(Duration(milliseconds: 0), () async {
                      await _signOut(context);
                    }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text("Error: ${snapshot.error}");
                      } else {
                        return Text("Logged out successfully!");
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Today's Tasks",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TasksList(
                tasks: [
                  Task(
                    title: 'Apprendre Flutter',
                    description:
                        'Suivre le cours pour apprendre de nouvelles compétences et pratiquer',
                    date: DateTime.now(),
                    category: Category.work,
                    isCompleted: true,
                  ),
                  Task(
                    title: 'Apprendre Flutter',
                    description:
                        'Suivre le cours pour apprendre de nouvelles compétences et pratiquer',
                    date: DateTime.now(),
                    category: Category.work,
                     isCompleted: true,
                  ),
                  Task(
                    title: 'Apprendre Flutter',
                    description:
                        'Suivre le cours pour apprendre de nouvelles compétences et pratiquer',
                    date: DateTime.now(),
                    category: Category.work,
                     isCompleted: true,
                  ),
                ],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _openAddTaskOverlay(context),
          child: const Icon(Icons.add),
        ));
  }
}
