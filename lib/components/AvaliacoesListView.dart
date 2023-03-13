import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DetalhesAvaliacao.dart';
import '../models/Avaliacao.dart';
import '../models/SharedViewModel.dart';

class AvaliacoesListView extends StatefulWidget {
  final List<Avaliacao> avaliacoes;
  final bool clicavel;

  AvaliacoesListView({required this.avaliacoes, required this.clicavel});

  @override
  _AvaliacoesListViewState createState() => _AvaliacoesListViewState();
}

class _AvaliacoesListViewState extends State<AvaliacoesListView> {
  @override
  Widget build(BuildContext context) {
    final List<Avaliacao> avaliacoes = widget.avaliacoes;
    avaliacoes
        .sort((a, b) => a.dataHoraRealizacao.compareTo(b.dataHoraRealizacao));

    return ListView.builder(
      itemCount: avaliacoes.length,
      itemBuilder: (context, index) {
        final avaliacao = avaliacoes[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Dismissible(
            key: UniqueKey(),
            background: Container(
              color: Colors.red,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            direction: widget.clicavel &&
                    Provider.of<SharedViewModel>(context)
                        .isBefore(avaliacoes[index].dataHoraRealizacao)
                ? DismissDirection.endToStart
                : DismissDirection.none,
            onDismissed: (direction) {
              setState(() {
                widget.avaliacoes.removeAt(index);
                const message =
                    'O registo de avaliação selecionado foi eliminado com sucesso.';
                const snackBar = SnackBar(
                  content: Text(
                    message,
                  ),
                  backgroundColor: Colors.red,
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
            child: Container(
                color: Provider.of<SharedViewModel>(context)
                        .isAfter(avaliacoes[index].dataHoraRealizacao)
                    ? const Color.fromRGBO(238, 210, 2, 0.7)
                    : Colors.transparent, // aqui é adicionado o fundo amarelo
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 15, top: 15),
                  child: ListTile(
                    title: Text(
                      avaliacao.disciplina,
                      style: const TextStyle(
                          color: Color(0xFF10497e),
                          fontWeight: FontWeight.w700),
                    ),
                    subtitle: Text(
                      'Nível de dificuldade: ${avaliacao.nivelDificuldade} \n${capitalize(avaliacao.tipoAvaliacao)} ',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    trailing: IntrinsicWidth(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.access_time,
                            size: 18,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 3),
                            child: Text(
                              avaliacao.dataHoraRealizacao
                                  .toString()
                                  .substring(0, 16),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalhesAvaliacao(
                                avaliacao: widget.avaliacoes[index],
                                index: index,
                                editavel: Provider.of<SharedViewModel>(context)
                                    .isBefore(
                                        avaliacoes[index].dataHoraRealizacao)),
                          ));
                      if (result != null) {
                        setState(() {
                          widget.avaliacoes[index] = result;
                        });
                      }
                    },
                  ),
                )),
          ),
        );
      },
    );
  }

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}
