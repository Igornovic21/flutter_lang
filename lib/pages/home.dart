import 'package:flutter/material.dart';
import 'package:flutter_lang/core/translation.dart';
import 'package:flutter_lang/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void changeLanguage(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(translation(context).modalTitle),
            content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                      onPressed: () {
                        MyApp.setLocale(context, const Locale('en', ""));
                        Navigator.pop(context);
                      },
                      child: const Text("English")),
                  TextButton(
                      onPressed: () {
                        MyApp.setLocale(context, const Locale('fr', ""));
                        Navigator.pop(context);
                      },
                      child: const Text("Francais"))
                ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(translation(context).appTitle), actions: [
          IconButton(
              onPressed: () => changeLanguage(context),
              icon: const Icon(Icons.language, color: Colors.white))
        ]),
        body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(translation(context).countPush),
          Text('$_counter', style: Theme.of(context).textTheme.headline4)
        ])),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _incrementCounter(),
            tooltip: translation(context).incr,
            child: const Icon(Icons.add)));
  }
}
