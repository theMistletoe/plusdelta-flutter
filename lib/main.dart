import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';
import 'list.dart';
import 'model/db/app_database.dart';
import 'model/entity/retro.dart';
import 'model/repository/retro_repository.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blueGrey,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ja'),
      ],
      home: const MyHomePage(title: 'Home'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
  final _plusThingController = TextEditingController();
  final _deltaThingController = TextEditingController();
  final _nextActionController = TextEditingController();

  @override
  void dispose() {
    _plusThingController.dispose();
    _deltaThingController.dispose();
    _nextActionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final repo = RetroRepository(AppDatabase());
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
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) => const ListPage(title: 'RetroHistory')
              ));
            },
            tooltip: 'Retro History',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Center(
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Padding(padding: EdgeInsets.all(30)),
                const Image(
                  width: 200,
                  image: AssetImage('images/logo_transparent.png')
                ),
                const Text(
                  'How was today?',
                  style: TextStyle(
                    fontSize: 18
                  ),
                ),
                const Text(
                  'Let’s retrospect good/bad things and\naction for improvement or enhauncement.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const Padding(padding: EdgeInsets.all(10)),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: '+',
                    hintText: 'Write things good or to continue'
                  ),
                  controller: _plusThingController,
                ),
                TextField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Δ',
                    hintText: 'Write things bad or to quit'
                  ),
                  controller: _deltaThingController,
                ),
              TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'NextAction',
                  hintText: 'Write Action for improvement'
                ),
                controller: _nextActionController,
              ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (
            _plusThingController.text == "" ||
            _deltaThingController.text == "" ||
            _nextActionController.text == ""
          ) {
            Fluttertoast.showToast(
              msg: "Input Something!",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: 25.0
            );
            return;
          }
          await repo.insert(
            Retro(
              id: const Uuid().v4(),
              plus: _plusThingController.text,
              delta: _deltaThingController.text,
              nextAction: _nextActionController.text,
              createdAt: DateTime.now()
            )
          );
          _plusThingController.clear();
          _deltaThingController.clear();
          _nextActionController.clear();
          Fluttertoast.showToast(
            msg: "Nice Retro!!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 25.0
          );
        },
        tooltip: '投稿',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
