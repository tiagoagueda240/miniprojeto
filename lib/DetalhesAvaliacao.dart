import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'components/DateTimePicker.dart';
import 'models/Avaliacao.dart';
import 'models/SharedViewModel.dart';

class DetalhesAvaliacao extends StatefulWidget {
  final Avaliacao avaliacao;
  final int index;
  final bool editavel;

  DetalhesAvaliacao(
      {required this.avaliacao, required this.index, required this.editavel});

  @override
  _DetalhesAvaliacaoState createState() => _DetalhesAvaliacaoState();
}

class _DetalhesAvaliacaoState extends State<DetalhesAvaliacao> {
  late TextEditingController _disciplinaController;
  late TextEditingController _tipoAvaliacaoController;
  late TextEditingController _nivelDificuldadeController;
  late TextEditingController _descricaoController;
  bool _editMode = false;
  final List<String> _tiposAvaliacao = [
    'frequência',
    'mini-teste',
    'projeto',
    'defesa'
  ];
  String tipoAvaliacao = 'frequência';

  @override
  void initState() {
    super.initState();

    _disciplinaController =
        TextEditingController(text: widget.avaliacao.disciplina);
    _tipoAvaliacaoController =
        TextEditingController(text: widget.avaliacao.tipoAvaliacao);
    tipoAvaliacao = widget.avaliacao.tipoAvaliacao;
    _nivelDificuldadeController = TextEditingController(
        text: widget.avaliacao.nivelDificuldade.toString());
    _descricaoController =
        TextEditingController(text: widget.avaliacao.descricao);
  }

  void _atualizarData(DateTime selectedDateTime) {
    setState(() {
      widget.avaliacao.dataHoraRealizacao = selectedDateTime;
    });
  }

  String shareText(Avaliacao avaliacao){
    return 'Vamos ter avaliação de ${avaliacao.disciplina}, em ${avaliacao.dataHoraRealizacao}, com a dificuldade de ${avaliacao.nivelDificuldade} numa escala de 1 a 5.\nObservações para esta avaliação: ${avaliacao.descricao}';
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Avaliação'),
        elevation: 0.0,
        actions: [
          IconButton(
            icon: Icon(_editMode ? null : Icons.share),
            color: Colors.white, // Altere a cor do ícone aqui
            onPressed: () {
              Share.share(shareText(widget.avaliacao));
            },
          ),
          IconButton(
            icon: Icon(_editMode ? Icons.check : Icons.edit),
            color: Colors.white, // Altere a cor do ícone aqui
            onPressed: () {
              if (widget.editavel) {
                setState(() {
                  _editMode = !_editMode;

                  widget.avaliacao.disciplina = _disciplinaController.text;
                  widget.avaliacao.nivelDificuldade =
                      int.parse(_nivelDificuldadeController.text);
                  widget.avaliacao.descricao = _descricaoController.text;
                  Provider.of<SharedViewModel>(context, listen: false)
                      .atualizaAvaliacao(widget.index, widget.avaliacao);
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Só podem ser editados registos de avaliações futuras.'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _disciplinaController,
                decoration: const InputDecoration(
                  labelText: 'Disciplina',
                ),
                enabled: _editMode,
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: "Tipo de avaliação",
                ),
                value: tipoAvaliacao, // valor inicial da avaliação
                items: _tiposAvaliacao.map((String tipo) {
                  return DropdownMenuItem<String>(
                    value: tipo,
                    child: Text(tipo),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    tipoAvaliacao = value!;
                    _tipoAvaliacaoController.text = value;
                  });
                },
              ),
              TextFormField(
                  controller: _nivelDificuldadeController,
                  decoration: const InputDecoration(
                    labelText: 'Nível de Dificuldade ( 1 - 5 )',
                  ),
                  enabled: _editMode,
                  autovalidateMode: AutovalidateMode.always,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isNotEmpty) {
                      final n = int.tryParse(value);
                      if (n == null || n < 1 || n > 5) {
                        return 'Escreva um número de 1 a 5';
                      }
                    }
                    return null;
                  }),
              const SizedBox(height: 16),
              buildDateInput(),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descricaoController,
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  labelText: 'Observações',
                ),
                enabled: _editMode,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      floatingActionButton: _editMode
          ? FloatingActionButton(
              onPressed: () {
                // Salva as alterações na avaliação
                setState(() {
                  widget.avaliacao.disciplina = _disciplinaController.text;
                  widget.avaliacao.nivelDificuldade =
                      int.parse(_nivelDificuldadeController.text);
                  widget.avaliacao.descricao = _descricaoController.text;
                  Provider.of<SharedViewModel>(context, listen: false)
                      .atualizaAvaliacao(widget.index, widget.avaliacao);
                });

                setState(() {
                  _editMode = false;
                });
              },
              backgroundColor: const Color(0xFF10497e),
              child: const Icon(Icons.save),
            )
          : null,
    );
  }

  Widget buildDateInput() {
    return DateTimePickerWidget(
      data: widget.avaliacao.dataHoraRealizacao,
      editavel: _editMode,
      onDateTimeChanged: _atualizarData,
    );
  }
}
