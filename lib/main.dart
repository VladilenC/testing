import 'dart:async';

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Testing',
      home: AnimApp(),
    );
  }
}

class AnimApp extends StatefulWidget {
  const AnimApp({super.key});

  @override
  AnimAppState createState() => AnimAppState();
}

class AnimAppState extends State<AnimApp> with TickerProviderStateMixin {
  int speed = 4;
  int direct = 0;
  double begin = 0.0;
  double end = 6.0;
  double pos = 0;

  late double screenWidth, screenHeight;
  dynamic stat;

  final StreamController<List<int>> _streamController =
      StreamController<List<int>>();
  final StreamController<List<int>> _streamController2 =
      StreamController<List<int>>();

  @override
  void dispose() {
    _streamController.close();
    _streamController2.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
      body: Container(
          child: StreamBuilder<List<int>>(
              stream: _streamController.stream,
              initialData: [10, 0, -1, 3],
              builder:
                  (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
                Size size = MediaQuery.of(context).size;
                screenHeight = size.height;
                screenWidth = size.width;

                speed = snapshot.data![0];
                begin = snapshot.data![2].toDouble();
                end = snapshot.data![3].toDouble();
                direct = snapshot.data![1].toInt();

                late AnimationController controller = AnimationController(
                  duration: Duration(seconds: speed),
                  vsync: this,
                )
                    //..repeat(reverse: true)
                    ;

                late Animation<Offset> offsetAnimation = Tween<Offset>(
                  begin: Offset(begin, 0.0),
                  end: Offset(end, 0.0),
                ).animate(CurvedAnimation(
                  parent: controller,
                  curve: Curves.linear,
                ));

                if (direct == 0) controller.forward();
                if (direct == 1) controller.reverse();

                offsetAnimation.addStatusListener((status) {
                  if (status == AnimationStatus.completed) {
                    controller.reverse();
                  } else if (status == AnimationStatus.dismissed) {
                    controller.forward();
                  }
                  if (status == AnimationStatus.forward) direct = 0;
                  if (status == AnimationStatus.reverse) direct = 0;
                  print('0000');
                  //       speed = int.parse(controller.duration.toString());
                  print('11111');
                  pos = offsetAnimation.value.dx;

                  print(direct.toString());

                  _streamController2.add(
                      [speed, direct, begin.toInt(), end.toInt(), pos.toInt()]);
                });
/*
controller.addListener(() {
  pos= offsetAnimation.value.dx;
//  print(controller.status.toString());
  if (controller.status == AnimationStatus.completed) {
    setState(() {

      pos = 0.0;
      print(pos.toString());


    });
    controller.forward(from: 0.0);

    }


});
*/
                return SlideTransition(
                  position: offsetAnimation,
                  child: const Padding(
                    padding: EdgeInsets.all(0.0),
                    child: FlutterLogo(size: 50.0),
                  ),
                );
              })),
      persistentFooterButtons: [
        StreamBuilder<List<int>>(
            stream: _streamController2.stream,
            initialData: [1, 0, 1, 1, 1],
            builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add([
                            4,
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3]
                          ]);
                        },
                        child: const Text('1')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add([
                            3,
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3]
                          ]);
                        },
                        child: const Text('2')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add([
                            2,
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3]
                          ]);
                        },
                        child: const Text('3')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add([
                            1,
                            snapshot.data![1],
                            snapshot.data![2],
                            snapshot.data![3]
                          ]);
                        },
                        child: const Text('4')),
                  ],
                ),
              );
            }),
      ],
    );
  }
}
