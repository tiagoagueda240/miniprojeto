import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DateTimePickerWidget extends StatefulWidget {
  final DateTime? data;
  final bool editavel;
  final void Function(DateTime selectedDateTime)? onDateTimeChanged;

  DateTimePickerWidget({required this.data, required this.editavel, this.onDateTimeChanged});

  @override
  _DateTimePickerWidgetState createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  late TextEditingController _textEditingController = TextEditingController();
  DateTime? _selectedDateTime;

  DateTime getNextMondayIfWeekend(DateTime date) {
    if (date.weekday == 6) { // sábado
      return date.add(const Duration(days: 2));
    } else if (date.weekday == 7) { // domingo
      return date.add(const Duration(days: 1));
    } else { // não é fim de semana
      return date;
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime ?? getNextMondayIfWeekend(DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      selectableDayPredicate: (DateTime date) {
        return date.weekday != 6 && date.weekday != 7;
      },
    );
    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime:
        TimeOfDay.fromDateTime(_selectedDateTime ?? DateTime.now()),
      );
      if (selectedTime != null) {
        final DateTime selectedDateTime = DateTime(picked.year, picked.month,
            picked.day, selectedTime.hour, selectedTime.minute);
        if (selectedDateTime.isBefore(DateTime.now())) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text('Data inválida'),
              content: const Text(
                  'A data selecionada deve ser no futuro, não no passado.'),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fechar'),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            _selectedDateTime = selectedDateTime;
            _textEditingController.text =
                selectedDateTime.toString().substring(0, 16);
          });
          if (widget.onDateTimeChanged != null) {
            widget.onDateTimeChanged!(selectedDateTime);
          }
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (_selectedDateTime != null) {
      _textEditingController.text =
          _selectedDateTime.toString().substring(0, 16);
    }else if(widget.data != null){
      _textEditingController.text = widget.data.toString().substring(0, 16);
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: _textEditingController,
          readOnly: true,
          onTap: () => _selectDateTime(context),
          decoration: const InputDecoration(
              labelText: 'Data e hora da realização',
              prefixIcon: Icon(Icons.date_range)
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Por favor, selecione uma data e hora.';
            }
            final dateTime = DateTime.tryParse(value);
            if (dateTime == null) {
              return 'Formato de data e hora inválido.';
            }
            if (dateTime.isBefore(DateTime.now())) {
              return 'A data e hora devem ser no futuro.';
            }
            return null;
          },
          enabled: widget.editavel,
        ),
      ],
    );
  }


}