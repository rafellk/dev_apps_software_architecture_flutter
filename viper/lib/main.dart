import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
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
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Router.buildView(),
    );
  }
}

abstract class PresenterProtocol {
  void updateUI(int counter);
}

abstract class InteractorProtocol {
  void didUpdateCounter(int counter);
}

class Router {
  static buildView() {
    Presenter presenter = Presenter();
    Interactor interactor = Interactor();
    Model model = Model();

    presenter.interactor = interactor;
    interactor.interface = presenter;
    interactor.model = model;

    return MyHomePage(presenter: presenter, interactor: interactor, model: model);
  }
}

class Presenter implements InteractorProtocol {
  PresenterProtocol interface;
  Interactor interactor;

  incrementCounter() {
    interactor.incrementCounter();
  }

  didUpdateCounter(int counter) {
    // birthDate.convert()
    interface.updateUI(counter);
  }
}

// adapter
class Interactor {
  InteractorProtocol interface;
  Model model;

  incrementCounter() {
    interface.didUpdateCounter(model.counter++);
  }
}

class Model {
  int counter = 0;
}

// View
class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.presenter, this.interactor, this.model}) : super(key: key);

  final Presenter presenter;
  final Interactor interactor;
  final Model model;

  @override
  _MyHomePageState createState() => _MyHomePageState(presenter, interactor, model);
}

// View
class _MyHomePageState extends State<MyHomePage> implements PresenterProtocol {
  int _counter = 0;

  final Presenter presenter;
  final Interactor interactor;
  final Model model;

  _MyHomePageState(this.presenter, this.interactor, this.model) {
    presenter.interface = this;
  }

  _incrementCounter() {
    widget.presenter.incrementCounter();
  }

  updateUI(int counter) {
    setState(() { _counter = counter; });
  }

  @override
  Widget build(BuildContext context) {
    return MyHomeView(_counter, _incrementCounter);
  }
}

// View
class MyHomeView extends StatelessWidget {

  final int counter;
  final Function incrementCounter;

  MyHomeView(this.counter, this.incrementCounter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$counter',
              style: Theme.of(context).textTheme.display1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}