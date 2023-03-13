import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'components/AvaliacoesListView.dart';
import 'models/SharedViewModel.dart';

class AvaliacoesList extends StatelessWidget {
  const AvaliacoesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de avaliações'),
        elevation: 0.0,

      ),
      body: Column(
        children: [
          const SizedBox(height: 15),
          Expanded(
            child: AvaliacoesListView(avaliacoes: Provider.of<SharedViewModel>(context).list, clicavel: true),
          ),
        ],
      ),
    );

  }
}