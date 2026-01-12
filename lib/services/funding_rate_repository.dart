import 'dart:convert';
import 'dart:convert';
import 'package:frwin/models/funding_rate_data.dart';
import 'package:frwin/services/bybit_api_service.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

@injectable
class FundingRateRepository {
  final BybitApiService _apiService;
  final _logger = Logger();
  static const _cacheKeyPrefix = 'funding_rate_cache_';
  static const _cacheDuration = Duration(minutes: 5);

  FundingRateRepository(this._apiService);

  Future<List<FundingRateData>> getFundingRateHistory(
      String category, String symbol) async {
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_cacheKeyPrefix${category}_$symbol';

    final cachedData = prefs.getString(cacheKey);
    if (cachedData != null) {
      _logger.d('Cache hit for key: $cacheKey. Checking timestamp.');
      final decodedData = jsonDecode(cachedData);
      final timestamp = DateTime.parse(decodedData['timestamp']);

      if (DateTime.now().difference(timestamp) < _cacheDuration) {
        _logger.i('Cache is valid. Loading data from cache.');
        final List<dynamic> rates = decodedData['data'];
        final result = rates
            .map((item) => FundingRateData(
                  symbol: item['symbol'],
                  fundingRate: item['fundingRate'],
                  timestamp: DateTime.parse(item['timestamp']),
                ))
            .toList();
        _logger.d('Loaded ${result.length} items from cache.');
        return result;
      } else {
        _logger.i('Cache is expired. Fetching from API.');
      }
    } else {
      _logger.i('Cache miss for key: $cacheKey. Fetching from API.');
    }

    // If cache is old or doesn't exist, fetch from API
    final apiData = await _apiService.getFundingRateHistory(category, symbol);
    
    _logger.i('Saving ${apiData.length} items to cache with key: $cacheKey');
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