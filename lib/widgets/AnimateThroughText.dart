import 'package:flutter/material.dart';
import 'package:agends/constants.dart';
import 'package:agends/models/Task.dart';
import 'package:audioplayers/audioplayers.dart';


class AnimatedStrikeThroughText extends StatefulWidget {
  final String text;
  final int id;
  final int isDone;
  final VoidCallback updateTasks;

  final newTaskController = TextEditingController();

  AnimatedStrikeThroughText({required this.text, required this.id,required this.isDone, required this.updateTasks});

  @override
  _AnimatedStrikeThroughTextState createState() => _AnimatedStrikeThroughTextState();
}
class _AnimatedStrikeThroughTextState extends State<AnimatedStrikeThroughText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool taskDone = false;

  final scratchAudioPlayer = AudioPlayer();
  final doneAudioPlayer = AudioPlayer();

  @override
  void initState() {

    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    if(widget.isDone == 1){
      toggleStrikeThrough();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    scratchAudioPlayer.dispose();
    doneAudioPlayer.dispose();
    super.dispose();
  }

  void playSoundWhenDone() async{
    await scratchAudioPlayer.play(AssetSource('sounds/scratching3sec.mp3')).then((result){
       doneAudioPlayer.play(AssetSource('sounds/done.mp3'));
    });



  }
  void playSoundUndo() async {
    await scratchAudioPlayer.play(AssetSource('sounds/scratching3sec.mp3'));
  }

  void toggleStrikeThrough() {


    setState(() {
      if (_controller.isCompleted) {
        _controller.reverse();
      } else {
        _controller.forward();
      }
    });
    taskDone = !taskDone;
    if (taskDone) {
      playSoundWhenDone();
    } else {
      playSoundUndo();
    }
    int isTaskFinallyDone = taskDone ? 1 : 0;
    Task.updateTask(widget.id, widget.text, isTaskFinallyDone);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        toggleStrikeThrough();
        // playSounds();
        },
      onLongPress: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              // title: Text(''),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () {
                      // Perform edit task
                      Navigator.of(context).pop();
                      widget.newTaskController.text = widget.text;
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            actions: [
                              TextField(
                                controller: widget.newTaskController,
                                autofocus: true,
                              ),
                              Row(children: [
                                IconButton(
                                  icon: Icon(Icons.done),
                                  onPressed: () {

                                    if(!widget.newTaskController.text.isEmpty){

                                      String content = widget.newTaskController.text;
                                      int done = widget.isDone;
                                      Task.updateTask(widget.id, content, widget.isDone);
                                      setState(() {
                                      });
                                      widget.updateTasks();
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
                      // Navigator.of(context).pop();
                    },
                  ), //edit button
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      print('deleted ${widget.id}');
                      Task.deleteTask(widget.id);
                      widget.updateTasks();
                      Navigator.of(context).pop();
                    },
                  ), //delete task
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () {
                      // Close the prompt or dialog
                      Navigator.of(context).pop();
                    },
                  ), //close dialogue
                ],
              ),
            ); //long press a task
          },
        );
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (BuildContext context, Widget? child) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: Stack(
              children:[
                SizedBox(width: double.infinity ,),
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/singleLineOfPage.png',
                    fit: BoxFit.fill,
                    repeat: ImageRepeat.repeat,
                    height: MediaQuery.of(context).size.height * 1.5,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:60),
                  child: Stack(
                  children: [

                    Text(
                      widget.text,
                      style: TextStyle(
                        fontSize: taskFontSize,
                        color: taskFontColor,
                        fontFamily: taskFontFamily,
                        decoration: taskDone
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        decorationColor: Colors.white, // Customize the color as needed
                        decorationThickness: 0.01, // Customize the thickness as needed
                      ),
                    ),
                    Positioned.fill(
                      child: CustomPaint(
                        painter: StrikeThroughPainter(
                          color: strikeThroughColor,
                          thickness: 10.0, // Customize the thickness as needed
                          progress: _animation.value,
                        ),
                      ),
                    ),
                  ],
              ),
                ),
          ]
            ),
          );
        },
      ),
    );
  }
}


class StrikeThroughPainter extends CustomPainter {
  final Color color;
  final double thickness;
  final double progress;

  StrikeThroughPainter({required this.color, required this.thickness, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    final y = size.height / 2;

    final path = Path();
    path.moveTo(0, y);
    path.lineTo(size.width * progress, y);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
