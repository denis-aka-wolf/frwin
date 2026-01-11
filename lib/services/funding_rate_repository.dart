import 'dart:convert';
import 'dart:convert';
import 'package:frwin/models/funding_rate_data.dart';
import 'package:frwin/services/bybit_api_service.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class FundingRateRepository {
  final BybitApiService _apiService;
  static const _cacheKeyPrefix = 'funding_rate_cache_';
  static const _cacheDuration = Duration(minutes: 5);

  FundingRateRepository(this._apiService);

  Future<List<FundingRateData>> getFundingRateHistory(
      String category, String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix${category}_$symbol';

    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      final decodedData = jsonDecode(cachedData);
      final timestamp = DateTime.parse(decodedData['timestamp']);

      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        final List<dynamic> rates = decodedData['data'];
        return rates
            .map((item) => FundingRateData(
                  symbol: item['symbol'],
                  fundingRate: item['fundingRate'],
                  timestamp: DateTime.parse(item['timestamp']),
                ))
            .toList();
      }
    }

    // If cache is old or doesn't exist, fetch from API
    final apiData = await _apiService.getFundingRateHistory(category, symbol);
    
    // Save to cache
    final dataToCache = {
      'timestamp': DateTime.now().toIso8601String(),
      'data': apiData
          .map((rate) => {
                'symbol': rate.symbol,
                'fundingRate': rate.fundingRate,
                'timestamp': rate.timestamp.toIso8601String(),
              })
          .toList(),
    };
    await prefs.setString(cacheKey, jsonEncode(dataToCache));

    return apiData;
  }
}