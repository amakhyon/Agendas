

import 'package:agends/models/Task.dart';


class TaskController {

  static List<dynamic> Tasks =[];

  static String getTaskContent(Task task){
    return task.content;
  }
  static int isTaskDone(Task task){
    return task.done;
  }
  static String getDateCreated(Task task){
    return task.dateCreated;
  }
  static String getDateDone(Task task){
    return task.dateDone;
  }
}