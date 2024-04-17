import 'package:bloc/bloc.dart';
import '../../data/repositories/http_currency_repository.dart';

class CurrencyConverterCubit extends Cubit<List<String>> {
  final HttpCurrencyRepository _currencyRepository = HttpCurrencyRepository();
  CurrencyConverterCubit() : super([]);

  String fromCurrency = '';

  void setFromCurrency(String currency) {
    fromCurrency = currency;
  }

  Future<void> loadTargetCurrencies() async {
    try {
      emit(await _currencyRepository.loadTargetCurrencies(fromCurrency));
    } catch (e) {
      throw Exception('Failed to load target currencies: $e');
    }
  }

  Future<void> convertCurrency(String fromCurrency, String to, double amount) async {
    try {
      final convertedAmount = await _currencyRepository.convertCurrency(fromCurrency, to, amount);
      emit([convertedAmount.toString()]);
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }
  Future<void> loadInitialTargetCurrencies() async {
    try {
      List<String> currencies = await _currencyRepository.loadInitialTargetCurrencies();
      setInitialTargetCurrencies(currencies);
    } catch (e) {
      throw Exception('Failed to load initial target currencies: $e');
    }
  }

  void setInitialTargetCurrencies(List<String> currencies) {
    emit(currencies);
  }

}
