import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/currency_converter_cubit.dart';

class CurrencyConverterScreen extends StatefulWidget {
  const CurrencyConverterScreen({super.key});

  @override
  CurrencyConverterScreenState createState() => CurrencyConverterScreenState();
}

class CurrencyConverterScreenState extends State<CurrencyConverterScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'USD';
  String _toCurrency = 'EUR';
  final List<String> baseCurrencies = ['USD', 'RUB', 'TRY'];
  List<String> targetCurrencies = [];

  @override
  void initState() {
    super.initState();
    _loadTargetCurrencies();
  }

  Future<void> _loadTargetCurrencies() async {
    try {
      await context.read<CurrencyConverterCubit>().loadInitialTargetCurrencies();
      List<String> currencies = context.read<CurrencyConverterCubit>().state;
      setState(() {
        targetCurrencies = currencies;
        _toCurrency = currencies.isNotEmpty ? currencies[0] : '';
      });
    } catch (e) {
      debugPrint('Failed to load target currencies: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Converter'),
      ),
      body: BlocConsumer<CurrencyConverterCubit, List<String>>(
        listener: (context, state) {
          if (state == 0.0) {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Error'),
                content: const Text('Failed to convert currency'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Enter amount',
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    DropdownButton<String>(
                      value: _fromCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          _fromCurrency = newValue!;
                        });
                      },
                      items: baseCurrencies.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                    const Text('to'),
                    DropdownButton<String>(
                      value: _toCurrency,
                      onChanged: (String? newValue) {
                        setState(() {
                          _toCurrency = newValue!;
                        });
                      },
                      items: targetCurrencies.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    final amount = double.tryParse(_amountController.text) ?? 0.0;
                    context.read<CurrencyConverterCubit>().convertCurrency(_fromCurrency, _toCurrency, amount);
                  },
                  child: const Text('Convert'),
                ),
                const SizedBox(height: 16.0),
                Text('Converted amount: ${state.isNotEmpty ? state[0] : ""}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
