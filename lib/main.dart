import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:total_running/planner.dart';
import 'package:total_running/profile.dart';
import 'package:total_running/calculator.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Total Running',
      // theme: ThemeData.dark(useMaterial3: true),
      home: const HomePage(title: 'Total Running'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Running'),
      ),
      body: Center(
        child: Text('Total Running'),
      ),
    );
  }
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _screens = <Widget>[
    const Home(key: PageStorageKey('Home')),
    const Planner(key: PageStorageKey('Planner')),
    const Calculator(key: PageStorageKey('Calculator')),
    const Profile(key: PageStorageKey('Profile')),
  ];

  final PageController _pageController = PageController();
  void navigateToSelectedPage(int index){
    setState((){
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: _screens
      ),
      bottomNavigationBar:BottomNavigationBar(items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home', backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_view_month), label: 'Planner', backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Calculator', backgroundColor: Colors.deepPurple),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile', backgroundColor: Colors.deepPurple),
      ],
      currentIndex: _selectedIndex,
      onTap: navigateToSelectedPage,
      selectedItemColor: Theme.of(context).colorScheme.primary,

      ),

    );
  }
}
