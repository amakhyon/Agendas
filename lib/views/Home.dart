
import 'package:flutter/material.dart';
import 'package:agends/widgets/AnimateThroughText.dart';
import 'package:agends/models/Task.dart';
import 'package:agends/widgets/TaskList.dart';
class Home extends StatefulWidget {

  State<Home> createState() => _HomeState();

}

class _HomeState extends State<Home> {
  @override
  final newTaskController = TextEditingController();
  void createNewTaskPrompt(BuildContext context, TextEditingController newTaskController){
    newTaskController.text = '';

    print('tapped');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          actions: [
            TextField(
              controller: newTaskController,
              autofocus: true,
            ),
            Row(children: [
              IconButton(
                icon: Icon(Icons.done),
                onPressed: () {

                  if(!newTaskController.text.isEmpty){
                    int id = Task.idCounter++;
                    String content = newTaskController.text;
                    String dateCreated = DateTime.now().toString();
                    int done = 0;
                    String dateDone = '';
                    Task tasky = Task(id: id,content: content,done: done,
                        dateCreated: dateCreated, dateDone: dateDone);
                    Task.insertTask(tasky).then((result){});
                    setState(() {

                    });
                  }
                  Navigator.of(context).pop();
                },
              ), //create button
              Spacer(),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  // Perform edit task
                  Navigator.of(context).pop();
                },
              ),//close button
            ],),
          ],

        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: GestureDetector(
          onTap: () {
            createNewTaskPrompt(context, newTaskController);
          },
          child: Center(
            child: Text(
              'Agenda',
              style: TextStyle(
                color: Colors.deepPurple,
                fontFamily: 'HandWrittenCursive',
                fontSize: 30,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            // Positioned.fill(
            //   child: Image.asset(
            //     'assets/images/largeLinedPaper.jpg',
            //     fit: BoxFit.fill,
            //     repeat: ImageRepeat.repeat,
            //     height: MediaQuery.of(context).size.height * 1.5,
            //     width: MediaQuery.of(context).size.width,
            //   ),
            // ),
            TaskList(),
          ],

           ),
      ) ,
    );
  }

}
