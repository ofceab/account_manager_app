import 'package:account_manager_app/helpers/appTheme.dart';
import 'package:account_manager_app/models/transaction.dart';
import 'package:flutter/material.dart';

class AddTransactionDialog extends StatefulWidget {
  final Function addFunction;
  final String date;
  final double credit;
  final double debit;
  final String particular;
  final int indexOfTransaction;
  AddTransactionDialog({
    @required this.addFunction,
    this.date,
    this.credit,
    this.debit,
    this.particular,
    this.indexOfTransaction,
  }) : assert(addFunction != null);

  @override
  _AddTransactionDialogState createState() => _AddTransactionDialogState();
}

class _AddTransactionDialogState extends State<AddTransactionDialog> {
  TextEditingController _dateController;
  TextEditingController _amountController;
  TextEditingController _particularController;
  final _formKey = GlobalKey<FormState>();
  String _currentRadioValue;

  @override
  void initState() {
    _dateController = TextEditingController();
    _amountController = TextEditingController();
    _particularController = TextEditingController();

    //CHeck and complete field
    if (widget.date != null &&
        widget.credit != null &&
        widget.debit != null &&
        widget.particular != null &&
        widget.indexOfTransaction != null) {
      _currentRadioValue = widget.credit != 0
          ? widget.credit.toString()
          : widget.debit.toString();

      _dateController.text = widget.date;

      _amountController.text = widget.credit != 0
          ? widget.credit.toString()
          : widget.debit.toString();

      _particularController.text = widget.particular;
    }
    _currentRadioValue = 'credit';
    super.initState();
  }

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _particularController.dispose();
    _currentRadioValue = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        FlatButton(
            onPressed: () => _validateAndAddTransactionHandler(context),
            child: Text('Add')),
        FlatButton(
            onPressed: () => _cancelHandler(context), child: Text('Cancel')),
      ],
      content: Container(
        height: AppTheme.listItemHeight+150,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _dateController,
                validator: (String value) {
                  if (value.isEmpty) return 'Enter a date';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: DateTime.now().toString(),
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _amountController,
                validator: (String value) {
                  if (value.isEmpty) return 'Enter an amount';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              TextFormField(
                controller: _particularController,
                validator: (String value) {
                  if (value.isEmpty) return 'Enter a particular name';
                  return null;
                },
                decoration: InputDecoration(
                  labelText: 'Particular',
                ),
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Credit(+)'),
                  Radio<String>(
                      value: 'credit',
                      groupValue: _currentRadioValue,
                      onChanged: _chageRadioState),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Debit(-)'),
                  Radio<String>(
                      value: 'debit',
                      groupValue: _currentRadioValue,
                      onChanged: _chageRadioState),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
  //Radio Handler
  void _chageRadioState(String value) => this.setState(() {
        this._currentRadioValue = value;
      });

  //Get and build a transaction Object
  Transaction get _buildAndGetTransactionObject => Transaction(
      transactionDate: _dateController.text,
      particular: _particularController.text,
      credit: (_currentRadioValue == 'credit')
          ? double.parse(_amountController.text)
          : 0,
      debit: (_currentRadioValue == 'debit')
          ? double.parse(_amountController.text)
          : 0);

  void _validateAndAddTransactionHandler(BuildContext content) {
    if (this._formKey.currentState.validate()) {
      Transaction _transaction = _buildAndGetTransactionObject;

      //Send the transaction object
      widget.addFunction(_transaction);
      _cancelHandler(context);
    }
  }

  //Cancel handler
  void _cancelHandler(BuildContext context) => Navigator.pop(context);
}
