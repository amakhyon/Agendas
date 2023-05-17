
import 'package:flutter/material.dart';
import 'package:agends/widgets/AnimateThroughText.dart';
import 'package:agends/models/Task.dart';


class TaskList extends StatefulWidget {
  const TaskList({Key? key}) : super(key: key);

  @override
  State<TaskList> createState() => _TaskListState();

}

class _TaskListState extends State<TaskList> {
  // List<Map<String, dynamic>>

  List<Widget> taskWidgets = [];

  void initState() {
    super.initState();
    getTaskList();
  }

  void didUpdateWidget(TaskList tasklist){
    super.didUpdateWidget(tasklist);
    getTaskList();
  }
  Future<void> getTaskList() async {
    taskWidgets = [];
    print('getting tasks..');
   List<Task> tasks = [];
   List<Widget> taskWidgetsList = [];

   tasks = await Task.readTasks();
   // taskWidgets.add(SizedBox(height:100));
   tasks.forEach((element) {
     taskWidgets.add(
         AnimatedStrikeThroughText(text: element.content, id: element.id, isDone: element.done, updateTasks: getTaskList,),
     );
     // taskWidgets.add(SizedBox(height:20));
     print(element.content);
   });
   setState(() {
     taskWidgets;
   });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: taskWidgets,
    );
  }
}
