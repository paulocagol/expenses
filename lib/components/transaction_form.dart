import 'package:expenses/components/adaptative_button.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionForm extends StatefulWidget {
  final void Function(String, double, DateTime) onSubmit;

  TransactionForm(this.onSubmit);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final _titleController = TextEditingController();
  final _valueController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  _submitForm() {
    final title = _titleController.text;
    final value = double.tryParse(_valueController.text) ?? 0.0;

    if (title.isEmpty || value <= 0 || _selectedDate == null) return;

    widget.onSubmit(title, value, _selectedDate);
  }

  _isShowdatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2019),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) {
        return;
      }

      setState(() {
        _selectedDate = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 10,
              right: 10,
              left: 10,
              bottom: 40,
            ),
            child: Column(
              children: [
                TextField(
                  controller: _titleController,
                  onSubmitted: (_) => _submitForm(),
                  decoration: InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  onSubmitted: (_) => _submitForm(),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  controller: _valueController,
                  decoration: InputDecoration(labelText: 'Valor (R\$)'),
                ),
                Container(
                  height: 70,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(_selectedDate == null
                            ? 'Nenhuma data selecionada'
                            : 'Data Selecionada: ${DateFormat('dd/MM/yyyy').format(_selectedDate)}'),
                      ),
                      FlatButton(
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _isShowdatePicker,
                        child: Text('Selecionar Data'),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AdaptativeButton(
                      label: 'Nova Transação',
                      onPressed: _submitForm,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
