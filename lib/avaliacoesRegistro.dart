import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miniprojeto/models/Avaliacao.dart';
import 'package:provider/provider.dart';

import 'components/DateTimePicker.dart';
import 'models/SharedViewModel.dart';

class AvaliacoesRegistro extends StatefulWidget {
  const AvaliacoesRegistro({super.key});

  @override
  _AvaliacoesRegistroState createState() => _AvaliacoesRegistroState();
}

class _AvaliacoesRegistroState extends State<AvaliacoesRegistro> {
  final nomeDisciplinaController = TextEditingController();
  final tipoAvaliacaoController = TextEditingController();
  final nivelDificuldadeController = TextEditingController();
  final observacoesController = TextEditingController();

  String? _tipoAvaliacao;
  final List<String> _tiposAvaliacao = [
    'frequência',
    'mini-teste',
    'projeto',
    'defesa'
  ];
  DateTime _selectedDate = new DateTime.now();
  bool _isValid = false;

   void validateInputs() {
    bool isValid = nomeDisciplinaController.text.isNotEmpty &&
        _tipoAvaliacao != null &&
        nivelDificuldadeController.text.isNotEmpty &&
        double.tryParse(nivelDificuldadeController.text) != null &&
        observacoesController.text.isNotEmpty &&
        observacoesController.text.length <= 200;

    setState(() {
      _isValid = isValid;
    });
  }

  void _atualizarData(DateTime selectedDateTime) {
    setState(() {
      _selectedDate = selectedDateTime;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Registo de avaliação'),
          elevation: 0.0,
        ),
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 40.0),
                buildNomeDisciplina(),
                const SizedBox(height: 16.0),
                buildTipoAvaliacao(),
                const SizedBox(height: 16.0),
                DateTimePickerWidget(data: null, editavel: true, onDateTimeChanged: _atualizarData),
                const SizedBox(height: 16.0),
                buildNivelDificuldade(),
                const SizedBox(height: 16.0),
                buildObservacoes(),
                const SizedBox(height: 16.0),
                buildButton()
              ],
            ),
          ),
        ));
  }

  Widget buildNomeDisciplina() => TextFormField(
        controller: nomeDisciplinaController,
        decoration: const InputDecoration(
            labelText: "Nome da disciplina", prefixIcon: Icon(Icons.school)),
        validator: (value) {
          return value!.isEmpty ? "Introduza uma disciplina" : null;
        },
      );

  Widget buildTipoAvaliacao() => DropdownButtonFormField<String>(
        decoration: const InputDecoration(
            labelText: "Tipo de avaliação", prefixIcon: Icon(Icons.merge_type)),
        value: null,
        items: _tiposAvaliacao.map((String tipo) {
          return DropdownMenuItem<String>(
            value: tipo,
            child: Text(tipo),
          );
        }).toList(),
        onChanged: (value) {
          setState(() {
            _tipoAvaliacao = value;
            tipoAvaliacaoController.text = value!;
          });
        },
      );

  Widget buildNivelDificuldade() => TextFormField(
        controller: nivelDificuldadeController,
        decoration: const InputDecoration(
            labelText: "Nível de dificuldade ( 1-5 )",
            prefixIcon: Icon(Icons.announcement)),
        keyboardType: TextInputType.number,
        autovalidateMode: AutovalidateMode.always,
        validator: (value) {
          if (value!.isEmpty) {
            return null;
          }
          final n = int.tryParse(value);
          if (n == null || n < 1 || n > 5) {
            return 'Informe um número de 1 a 5';
          }
          return null;
        },
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.digitsOnly
        ],
      );

  Widget buildObservacoes() => TextField(
        controller: observacoesController,
        maxLength: 200,
        keyboardType: TextInputType.multiline,
    maxLines: null,
        decoration: const InputDecoration(
            hintText: "Observações",
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1, color: Colors.black))),
      );

  Widget buildButton() => FloatingActionButton(
        onPressed: () {
          validateInputs();
          if (_isValid) {
            nomeDisciplinaController.clear();

            tipoAvaliacaoController.clear();
            nivelDificuldadeController.clear();
            observacoesController.clear();
            Provider.of<SharedViewModel>(context, listen: false).add(Avaliacao(
                disciplina: nomeDisciplinaController.text,
                nivelDificuldade: int.parse(nivelDificuldadeController.text),
                tipoAvaliacao: _tipoAvaliacao!,
                dataHoraRealizacao: _selectedDate,
                descricao: observacoesController.text));
            setState(() {
              _tipoAvaliacao = null;
              _selectedDate = DateTime.now();
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('A avaliação foi registada com sucesso.'),
                duration: Duration(seconds: 2),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Preencha corretamente o formulário'),
                duration: Duration(seconds: 2),
              ),
            );
          }
        },
        backgroundColor: const Color(0xFF10497e),
        child: const Icon(Icons.create),
      );
}
