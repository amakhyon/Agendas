
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:uuid/uuid.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class Task {

  final int id; final String content; final  int done;
  final String dateCreated; final String dateDone;

  // Task( this.id, this.content, this.done, this.dateCreated, this.dateDone);
  static int idCounter =0;
  const Task({required this.id, required this.content,required this.done,
    required this.dateCreated,required this.dateDone});

  Map<String, dynamic> toMap(){
    return {
      'content':content,
      'done': done,
      'dateCreated':dateCreated,
      'dateDone':dateDone,
    };
  }
  String toString(){
    return 'Task{id: $id, content: $content, done: $done, dateCreated: $dateCreated, dateDone: $dateDone';
  }

  int getId(Task task){
    return task.id;
  }
  String getContent(Task task){
    return task.content;
  }
  String getDateCreated(Task task){
    return task.dateCreated;
  }
  int getDone(Task task){
    return task.done;
  }

  static Future<Database> createDatabase() async{
    WidgetsFlutterBinding.ensureInitialized();
    return  openDatabase(
        join(await getDatabasesPath(), 'tasks_database.db'),
        onCreate: (db,version){
    return db.execute(
    'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, content TEXT,done INTEGER, dateCreated TEXT, dateDone TEXT)',
    );
    },

    version: 2,
    );
  }

  static Future<void> insertTask(Task task) async {

    final db = await createDatabase();
    await db.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  static Future<List<Task>> readTasks() async {
    final db = await createDatabase();
    final List<Map<String, dynamic>> maps = await db.query('tasks');
    return List.generate(maps.length, (i){
      return Task(
        id: maps[i]['id'],
        content: maps[i]['content'],
        done: maps[i]['done'],
        dateCreated: maps[i]['dateCreated'],
        dateDone: maps[i]['dateDone'],
      );
    });
  }
  static Future<void> updateTask(int taskId, String taskContent, int isTaskDone) async {
    final db = await createDatabase();
    Task task = Task(id: taskId, content: taskContent, done: isTaskDone, dateCreated: '',dateDone: '');
    await db.update(
      'tasks',
      task.toMap(),
      where: 'id=?',
      whereArgs: [task.id],
    );
  }
  static Future<void> deleteTask(int id) async {
    final db = await createDatabase();

    await db.delete(
      'tasks',
      where: 'id=?',
      whereArgs: [id],
    );
  }

}

// void main() async {
//
//
//   Task maybe;
//   maybe = Task(
//     id: Task.idCounter++,
//     content: 'bark bark bark bark',
//     done: 0,
//     dateCreated: '12/2/333',
//     dateDone: '',
//   );
//   await insertTask(maybe);
//   await readTasks().then((result){
//     print(result);
//   });
//   maybe = Task(
//     id:1,
//     content: 'haw haw haw haw',
//     done: 1,
//     dateCreated: '12/2/333',
//     dateDone: '12/2/334',
//   );
//   await updateTask(maybe);
//   await readTasks().then((result){
//     print(result);
//   });
//   await deleteTask(1);
//   await readTasks().then((result){
//     print(result);
//   });
//
// }
//
