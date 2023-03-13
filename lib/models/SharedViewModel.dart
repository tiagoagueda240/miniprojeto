import 'Avaliacao.dart';
import 'package:flutter/foundation.dart';


class SharedViewModel extends ChangeNotifier {
  final List<Avaliacao> _list = [
    Avaliacao(
      disciplina: 'Matemática Discreta',
      nivelDificuldade: 3,
      tipoAvaliacao: 'frequência',
      dataHoraRealizacao: DateTime.now().add(Duration(days: 1)),
      descricao: '',
    ),
    Avaliacao(
      disciplina: 'Programação II',
      nivelDificuldade: 2,
      tipoAvaliacao: 'projeto',
      dataHoraRealizacao: DateTime.now().add(Duration(days: 10)),
      descricao: '',
    ),
    Avaliacao(
      disciplina: 'Matemática I',
      nivelDificuldade: 1,
      tipoAvaliacao: 'frequência',
      dataHoraRealizacao: DateTime.now(),
      descricao: '',
    ),
    Avaliacao(
      disciplina: 'Matemática III',
      nivelDificuldade: 1,
      tipoAvaliacao: 'frequência',
      dataHoraRealizacao: DateTime.now().add(Duration(days: 3)),
      descricao: '',
    ),
  ];

  List<Avaliacao> get list => _list;


  double getMediaDificuldade() {
    double media = 0;
    _list.forEach((a) => media += a.nivelDificuldade);
    return media / _list.length;
  }

  List<Avaliacao> getAvaliacoesProximos7Dias() {
    DateTime yesterday = DateTime.now().subtract(Duration(days: 1));
    DateTime next7Days = yesterday.add(Duration(days: 7));
    return _list.where((a) => a.dataHoraRealizacao.isBefore(next7Days) && a.dataHoraRealizacao.isAfter(yesterday)).toList();
  }

  List<Avaliacao> getAvaliacoesEntre7e14Dias() {
    DateTime today = DateTime.now();
    DateTime next7Days = today.add(Duration(days: 7));
    DateTime next14Days = today.add(Duration(days: 14));
    return _list
        .where((a) => a.dataHoraRealizacao.isAfter(next7Days) && a.dataHoraRealizacao.isBefore(next14Days))
        .toList();
  }

  bool isBefore(DateTime dia) {
    return dia.isAfter(DateTime.now()) ;
  }

  bool isAfter(DateTime dia) {
    return dia.isBefore(DateTime.now().add(Duration(days: 1))) || (DateTime.now().weekday == 5 && isNextMonday(dia)) ;
  }
  bool isNextMonday(DateTime date) {
    final nextMonday = DateTime.now().add(Duration(days: (8 - DateTime.now().weekday) % 7));
    final nextMondayDate = DateTime(nextMonday.year, nextMonday.month, nextMonday.day);
    final dateDate = DateTime(date.year, date.month, date.day);

    return dateDate == nextMondayDate;
  }

  double getMediaDificuldade7e14Dias() {
    List<Avaliacao> proximo14diasAvaliacoes = getAvaliacoesEntre7e14Dias();
    double media = 0;
    proximo14diasAvaliacoes.forEach((a) => media += a.nivelDificuldade);
    return media / _list.length;
  }

  void add(Avaliacao avaliacao) {
    _list.add(avaliacao);
    notifyListeners();
  }

  void removeAvaliacao(Avaliacao avaliaco) {
    _list.remove(avaliaco);
    notifyListeners();

  }

  void atualizaAvaliacao(int index, Avaliacao atual) {
    _list[index] = atual;
    notifyListeners();
  }
}
