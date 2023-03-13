import 'package:flutter_test/flutter_test.dart';
import 'package:miniprojeto/models/SharedViewModel.dart';

void main() {

  test('Média dos primeiro 7 dias', () {
    SharedViewModel viewModel = SharedViewModel();

    double expectedAverage = (3 + 2 + 1 + 1) / 4;
    expect(viewModel.getMediaDificuldade(), expectedAverage);
  });

  test('Média dos 7 a 14 dias', () {
    SharedViewModel viewModel = SharedViewModel();
    double actualAverage = viewModel.getMediaDificuldade7e14Dias();

    expect(actualAverage, equals(0.5));
  });



}