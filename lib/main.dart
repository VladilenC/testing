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
  late double screenWidth, screenHeight;
  var speed = 1000000;

  final StreamController<List<dynamic>> _streamController =
      StreamController<List<dynamic>>();
  final StreamController<List<dynamic>> _streamController2 =
      StreamController<List<dynamic>>();
  late AnimationController controller;
  late Animation<Offset> offsetAnimation;

  @override
  void dispose() {
    _streamController.close();
    _streamController2.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final screenWidth = size.width * 0.019;
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
      body: StreamBuilder<List<dynamic>>(
          stream: _streamController.stream,
          initialData: [10, AnimationStatus.forward, 0.0, screenWidth],
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            controller = AnimationController(
              duration: Duration(
                  microseconds: ((snapshot.data![3] - snapshot.data![2]) *
                          snapshot.data![0] ~/
                          screenWidth) +
                      1),
              vsync: this,
            );

            offsetAnimation = Tween<Offset>(
              begin: Offset(snapshot.data![2], 5.0),
              end: Offset(snapshot.data![3], 5.0),
            ).animate(CurvedAnimation(
              parent: controller,
              curve: Curves.linear,
            ));

            if (snapshot.data![1] == AnimationStatus.forward) {
              controller.forward();
            }
            if (snapshot.data![1] == AnimationStatus.reverse) {
              controller.reverse(from: snapshot.data![3]);
            }

            offsetAnimation.addListener(() {
              var pos = offsetAnimation.value.dx;
              var status = controller.status;
              var dur = controller.duration!.inSeconds;
              if (pos != 0.0 && pos != screenWidth) {
                _streamController2.add([dur, status, 0.0, screenWidth, pos]);
              } else if (status == AnimationStatus.completed) {
                controller.reverse();
                _streamController2
                    .add([dur, AnimationStatus.reverse, 0.0, screenWidth, pos]);
              } else if (status == AnimationStatus.dismissed) {
                controller.forward();
                _streamController2
                    .add([dur, AnimationStatus.forward, 0.0, screenWidth, pos]);
              }
            });

            return SlideTransition(
              position: offsetAnimation,
              child: const Padding(
                padding: EdgeInsets.all(0.0),
                child: FlutterLogo(size: 50.0),
              ),
            );
          }),
      persistentFooterButtons: [
        StreamBuilder<List<dynamic>>(
            stream: _streamController2.stream,
            initialData: [1, 0, 0.0, screenWidth, 0.0],
            builder:
                (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
              var pos = snapshot.data![4];
              var dir = snapshot.data![1];
              if (pos == screenWidth) {
                _streamController.sink
                    .add([speed, AnimationStatus.reverse, 0.0, screenWidth]);
              }
              if (pos == 0.0) {
                _streamController.sink
                    .add([speed, AnimationStatus.forward, 0.0, screenWidth]);
              }

              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          speed = 4000000;
                          if (dir == AnimationStatus.forward) {
                            _streamController.sink.add([
                              (speed * (screenWidth - pos)) ~/ screenWidth,
                              AnimationStatus.forward,
                              pos,
                              screenWidth
                            ]);
                          } else {
                            _streamController.sink.add([
                              (speed * pos) ~/ screenWidth,
                              AnimationStatus.reverse,
                              0.0,
                              pos
                            ]);
                          }
                        },
                        child: const Text('1')),
                    ElevatedButton(
                        onPressed: () {
                          speed = 3000000;
                          if (dir == AnimationStatus.forward) {
                            _streamController.sink.add([
                              (speed * (screenWidth - pos)) ~/ screenWidth,
                              AnimationStatus.forward,
                              pos,
                              screenWidth
                            ]);
                          } else {
                            _streamController.sink.add([
                              (speed * pos) ~/ screenWidth,
                              AnimationStatus.reverse,
                              0.0,
                              pos
                            ]);
                          }
                        },
                        child: const Text('2')),
                    ElevatedButton(
                        onPressed: () {
                          speed = 2000000;
                          if (dir == AnimationStatus.forward) {
                            _streamController.sink.add([
                              (speed * (screenWidth - pos)) ~/ screenWidth,
                              AnimationStatus.forward,
                              pos,
                              screenWidth
                            ]);
                          } else {
                            _streamController.sink.add([
                              (speed * pos) ~/ screenWidth,
                              AnimationStatus.reverse,
                              0.0,
                              pos
                            ]);
                          }
                        },
                        child: const Text('3')),
                    ElevatedButton(
                        onPressed: () {
                          speed = 1000000;
                          if (dir == AnimationStatus.forward) {
                            _streamController.sink.add([
                              (speed * (screenWidth - pos)) ~/ screenWidth,
                              AnimationStatus.forward,
                              pos,
                              screenWidth
                            ]);
                          } else {
                            _streamController.sink.add([
                              (speed * pos) ~/ screenWidth,
                              AnimationStatus.reverse,
                              0.0,
                              pos
                            ]);
                          }
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
