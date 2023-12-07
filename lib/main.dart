import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in a Flutter IDE). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // Flutter给原生传值：
  static const methodChannel = const MethodChannel('hi_flutter_module_flutter_to_iOS');
  // 原生给Flutter传值：
  static const eventChannel = const EventChannel('hi_flutter_module_iOS_to_flutter');

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  // 渲染前的操作，类似viewDidLoad
  @override
  void initState() {
    super.initState();
    // 监听事件，同时发送参数12345
    eventChannel.receiveBroadcastStream(12345).listen((value) {
      print('接受的值 $value');
    }, onError: (error) {
      print('发生错误');
    }, onDone: () {
      print('监听结束');
    }, cancelOnError: true);
  }
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: Container(
          color: Colors.red,
          child: GestureDetector(
            onTap: () {
              methodChannel.invokeMethod('backToViewController');
            },
            child:const Icon(
              Icons.arrow_back,
             color: Colors.white
            ),
          ),
        ),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Hi_Flutter_Module_engine',
            ),
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            InkWell(
              onTap:_plusOrigin,
              child: Container(child: Text(
                '给原生传值',
                style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
              ),margin: EdgeInsets.only(top:32),),
            ),
            InkWell(
              onTap:_getIosValue,
              child: Container(child: Text(
                '从原生拿值',
                style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
              ),margin: EdgeInsets.only(top:32),),
            ),
            InkWell(
              onTap:_toNext,
              child: Container(child: Text(
                '跳到下个界面',
                style: TextStyle(color: Colors.red,fontSize: 16,fontWeight: FontWeight.bold),
              ),margin: EdgeInsets.only(top:32),),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  _plusOrigin() async {
    Map<String, dynamic> value = {"name": "iOS 原生开发", "age":27, "certNo":"362324199610016010"};
    await methodChannel.invokeMapMethod('iOSFlutterMethod',value);
  }

  _getIosValue() async {
    dynamic result;
    try{
      Map<String, dynamic> value = {"name": "Flutter 与 iOS 交互测试", "age":27, "certNo":"362324199610016010"};
      result = await methodChannel.invokeMethod('flutterIOSMethod',value);
      print("result_______$result");
    } on PlatformException {
      result = "error";
    }
  }

  _toNext() async {
    await methodChannel.invokeMapMethod('iOSFlutterMethodToPage');
  }
}
