import 'package:flutter/material.dart';

import 'model/db/app_database.dart';
import 'model/entity/retro.dart';
import 'model/repository/retro_repository.dart';

class ListPage extends StatefulWidget {
  const ListPage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Retro>> fetch() async {
    return await RetroRepository(AppDatabase()).loadAllRetro();
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
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [FutureBuilder<List>(
              future: fetch(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  var data = snapshot.data;
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: data?.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: double.infinity,
                        alignment: Alignment.topLeft,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 1.0)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "+",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              data?[index].plus,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            const Text(
                              "Δ",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey
                              ),
                            ),
                            Text(
                              data?[index].delta,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            const Padding(padding: EdgeInsets.all(5)),
                            const Text(
                              "NextAction",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey
                              ),
                            ),
                            Text(
                              data?[index].nextAction,
                              textAlign: TextAlign.left,
                              style: const TextStyle(fontSize: 15.0),
                            ),
                            Container(
                              alignment: Alignment.bottomRight,
                              child:
                                Text(
                                  data?[index]?.getCreatedAt(),
                                  textAlign: TextAlign.left,
                                  style: const TextStyle(
                                    fontSize: 12.0,
                                    color: Colors.grey
                                  ),
                                ),
                            )
                          ]
                        )
                      );
                    },
                  );
                }
                return const Text('Loading...');
              },
              )],
            )
          ),
        ),
      ),
    );
  }
}
