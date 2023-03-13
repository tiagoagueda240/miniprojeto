import 'package:flutter_test/flutter_test.dart';
import 'package:miniprojeto/DetalhesAvaliacao.dart';
import 'package:miniprojeto/models/Avaliacao.dart';

void main() {
  test(
      'getMediaDificuldade should return the average difficulty level of all evaluations',
      () {
    DateTime date = DateTime.now().add(Duration(days: 1));
    final state = DetalhesAvaliacao(
            avaliacao: Avaliacao(
              disciplina: 'Matemática Discreta',
              nivelDificuldade: 3,
              tipoAvaliacao: 'frequência',
              dataHoraRealizacao: date,
              descricao: '',
            ),
            index: 1,
            editavel: false)
        .createState();

    expect(state.tipoAvaliacao, "frequência");
    expect(
        state.shareText(Avaliacao(
          disciplina: 'Matemática Discreta',
          nivelDificuldade: 3,
          tipoAvaliacao: 'frequência',
          dataHoraRealizacao: date,
          descricao: '',
        )),
        'Vamos ter avaliação de Matemática Discreta, em ${date}, com a dificuldade de 3 numa escala de 1 a 5.\n'
        'Observações para esta avaliação: ');
  });
}
