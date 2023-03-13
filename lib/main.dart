import 'package:flutter/material.dart';
import 'package:miniprojeto/models/SharedViewModel.dart';
import 'package:provider/provider.dart';
import 'avaliacoesList.dart';
import 'avaliacoesRegistro.dart';
import 'dashboard.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;

  final List<Widget> _childrenWidgets = [
    const Dashboard(),
    AvaliacoesList(),
    const AvaliacoesRegistro(),
  ];

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SharedViewModel(),
      child: MaterialApp(
        title: 'iQueChumbei',
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(color: Colors.black),
            color: Color(0xFF10497e),
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: Color(0xFFeef5ff),
            selectedItemColor: Color(0xFF10497e),
            unselectedItemColor: Colors.grey,
          ),
          scaffoldBackgroundColor: const Color(0xFFeef5ff),
        ),
        home: Scaffold(
          body: _childrenWidgets[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            onTap: onTabTapped,
            currentIndex: _currentIndex,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.dashboard),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.list),
                label: 'Listagem',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.add),
                label: 'Registo',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
