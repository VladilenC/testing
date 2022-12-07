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
  double pos = 0;

  late double screenWidth, screenHeight;
  dynamic stat;

  final StreamController<int> _streamController = StreamController<int>.broadcast();
  final StreamController<int> _streamController2 = StreamController<int>();

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
      body: Column(children: [
        Container(
            child: StreamBuilder<int>(
                stream: _streamController.stream,
                initialData: 0,
                builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                  Size size = MediaQuery.of(context).size;
                  screenHeight = size.height;
                  screenWidth = size.width;
                  speed =snapshot.data!;
                  late AnimationController controller = AnimationController(
                    duration: Duration(seconds: speed),
                    vsync: this,
                  )
                    //..repeat(reverse: true)
                  ;

                  late Animation<Offset> offsetAnimation = Tween<Offset>(
                    begin: Offset((25-screenWidth)*0.01, 0.0),
                    end: Offset((screenWidth - 25) * 0.01, 0.0),
                  ).animate(CurvedAnimation(
                    parent: controller,
                    curve: Curves.linear,
                  ));
                  controller.forward();

                  offsetAnimation.addStatusListener((status) {
                    if (snapshot.hasData) {
                      speed = snapshot.data!;

                      print('speed: '+speed.toString());
                      if (speed > 0)
                            {  controller.duration=Duration(seconds: speed);}
                    }
                    if(status == AnimationStatus.completed) {
controller.duration=Duration(seconds: 10);
                      controller.reverse();
                    } else if(status == AnimationStatus.dismissed) {
                      controller.forward();
                    }
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
        Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: () {
                    _streamController.add(4);
                  },
                  child: const Text('1')),
              ElevatedButton(
                  onPressed: () {
                    _streamController.add(3);
                  },
                  child: const Text('2')),
              ElevatedButton(
                  onPressed: () {
                    _streamController.add(2);
                  },
                  child: const Text('3')),
              ElevatedButton(
                  onPressed: () {
                    _streamController.add(1);
                  },
                  child: const Text('4')),
              ElevatedButton(onPressed: () {}, child: const Text('5')),
            ],
          ),
        )
      ]),
      persistentFooterButtons: [
        StreamBuilder<int>(
            stream: _streamController2.stream,
            initialData: 4,
            builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
              return BottomAppBar(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add(4);
                        },
                        child: const Text('1')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add(3);
                        },
                        child: const Text('2')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add(2);
                        },
                        child: const Text('3')),
                    ElevatedButton(
                        onPressed: () {
                          _streamController.sink.add(1);
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
