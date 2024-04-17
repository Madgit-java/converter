
import '../../models/currency.dart';

abstract class CurrencyRepository {
  Future<List<Currency>> fetchCurrencies(String baseCurrency);
  Future<ConversionResult> convertCurrency(String from, String to, double amount);
}
