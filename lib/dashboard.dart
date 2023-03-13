import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:miniprojeto/components/AvaliacoesListView.dart';
import 'package:provider/provider.dart';

import 'models/Avaliacao.dart';
import 'models/SharedViewModel.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final contadorProvider = Provider.of<SharedViewModel>(context);
    final double _proximo7diasMediaDificuldade =
        contadorProvider.getMediaDificuldade();
    final double _proximo14diasMediaDificuldade =
        contadorProvider.getMediaDificuldade7e14Dias();
    final List<Avaliacao> _proximo7diasAvaliacoes =
        contadorProvider.getAvaliacoesProximos7Dias();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 0.0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            child: Center(
              child: Text(
                'Dificuldade média',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 38,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: buildDificuldadeMedia(
                _proximo7diasMediaDificuldade, _proximo14diasMediaDificuldade),
          ),
          const SizedBox(height: 32),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 20, 30, 20),
            child: Center(
              child: Text(
                'Avaliações dos próximos 7 dias',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "Varela",
                    fontSize: 22,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Expanded(
            child: AvaliacoesListView(
                avaliacoes: _proximo7diasAvaliacoes, clicavel: false),
          ),
        ],
      ),
    );
  }

  Widget buildDificuldadeMedia(double proximo7diasMediaDificuldade,
          double proximo14diasMediaDificuldade) =>
      SizedBox(
        height: 120,
        child: Row(
          children: [
            Expanded(
              child: Card(
                  color: Color(0xFF10497e),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      const Text(
                        'Próximos 7 dias',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        proximo7diasMediaDificuldade.toStringAsFixed(2),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ),
            Expanded(
              child: Card(
                  color: Color(0xFF10497e),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                      ),
                      const Text(
                        '7-14 dias',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        proximo14diasMediaDificuldade.toStringAsFixed(2),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      );
}
