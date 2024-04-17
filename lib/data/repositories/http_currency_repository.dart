import 'package:http/http.dart' as http;
import 'dart:convert';

class HttpCurrencyRepository {

  final link = 'https://v6.exchangerate-api.com/v6/567e2c3057302f28aa862bab/latest/';

  Future<List<String>> loadTargetCurrencies(String fromCurrency) async {
    try {
      final response = await http.get(Uri.parse('$link$fromCurrency'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> currencies = List<String>.from(data['conversion_rates'].keys);
        return currencies;
      } else {
        throw Exception('Failed to load target currencies');
      }
    } catch (e) {
      throw Exception('Failed to load target currencies: $e');
    }
  }

  Future<double> convertCurrency(String from, String to, double amount) async {
    try {
      final response = await http.get(Uri.parse('$link$from'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rates = data['conversion_rates'];
        final rate = rates[to];
        if (rate != null) {
          double convertedAmount = amount * rate;
          return convertedAmount;
        } else {
          throw Exception('Conversion rate not available');
        }
      } else {
        throw Exception('Failed to load exchange rates');
      }
    } catch (e) {
      throw Exception('Failed to convert currency: $e');
    }
  }

  Future<List<String>> loadInitialTargetCurrencies() async {
    try {
      final response = await http.get(Uri.parse('https://v6.exchangerate-api.com/v6/567e2c3057302f28aa862bab/latest/USD'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<String> currencies = List<String>.from(data['conversion_rates'].keys);
        return currencies;
      } else {
        throw Exception('Failed to load initial target currencies: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load initial target currencies: $e');
    }
  }


}
