import 'dart:async';

import 'package:flutter/material.dart';


class ContApp extends StatefulWidget {
  const ContApp({super.key});

  @override
  ContAppState createState() => ContAppState();
}

class ContAppState extends State<ContApp> {
  int _counter = 0;
  final StreamController<int> _streamController = StreamController<int>(); // Наш поток

  @override
  void dispose(){
    _streamController.close(); // Закрываем поток
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Testing')),
      body: Center(
        child: StreamBuilder<int>(
            stream: _streamController.stream, // Создаем и открываем поток
            initialData: _counter, // Наши данные из потока
            builder: (BuildContext context, AsyncSnapshot<int> snapshot){
              return Text('You hit me: ${snapshot.data} times'); // С помощью StreamBuilder получаем асинхронно данные из потока
            }
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: (){
          _streamController.sink.add(++_counter); // Изменяем данные в потоке (+1)
        },
      ),
   //   bottomNavigationBar: ,
    );
  }
}