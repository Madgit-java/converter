import 'package:converter/presentation/bloc/currency_converter_cubit.dart';
import 'package:converter/presentation/screens/currency_converter_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Currency Converter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (context) => CurrencyConverterCubit(),
        child: const CurrencyConverterScreen(),
      ),
    );
  }
}
