import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frwin/models/funding_rate_data.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class BybitApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;

  static const String _baseUrl = 'https://api.bybit.com';
  static const _apiKeyStore = 'bybit_api_key';
  static const _apiSecretStore = 'bybit_api_secret';

  BybitApiService()
      : _dio = Dio(),
        _secureStorage = const FlutterSecureStorage();

  Future<void> saveApiCredentials(String apiKey, String apiSecret) async {
    await _secureStorage.write(key: _apiKeyStore, value: apiKey);
    await _secureStorage.write(key: _apiSecretStore, value: apiSecret);
  }

  Future<List<InstrumentInfo>> getInstrumentsInfo(String category) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v5/market/instruments-info',
        queryParameters: {'category': category},
      );

      if (response.statusCode == 200 && response.data['retCode'] == 0) {
        final List<dynamic> instrumentList = response.data['result']['list'];
        return instrumentList
            .map((json) => InstrumentInfo(
                  symbol: json['symbol'],
                  baseCurrency: json['baseCoin'],
                  quoteCurrency: json['quoteCoin'],
                ))
            .toList();
      } else {
        throw Exception('Failed to load instrument info: ${response.data['retMsg']}');
      }
    } catch (e) {
      throw Exception('Failed to load instrument info: $e');
    }
  }

  Future<List<FundingRateData>> getFundingRateHistory(
      String category, String symbol, {int? limit}) async {
    try {
      final response = await _dio.get(
        '$_baseUrl/v5/market/funding/history',
        queryParameters: {
          'category': category,
          'symbol': symbol,
          'limit': limit ?? 200,
        },
      );

      if (response.statusCode == 200 && response.data['retCode'] == 0) {
        final List<dynamic> historyList = response.data['result']['list'];
        return historyList
            .map((json) => FundingRateData(
                  symbol: json['symbol'],
                  fundingRate: double.parse(json['fundingRate']),
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(json['fundingRateTimestamp'])),
                ))
            .toList();
      } else {
        throw Exception('Failed to load funding rate history: ${response.data['retMsg']}');
      }
    } catch (e) {
      throw Exception('Failed to load funding rate history: $e');
    }
  }

  // Placeholder for a method that might require authentication
  Future<void> getAccountInfo() async {
    final apiKey = await _secureStorage.read(key: _apiKeyStore);
    final apiSecret = await _secureStorage.read(key: _apiSecretStore);

    if (apiKey == null || apiSecret == null) {
      throw Exception('API credentials not set.');
    }

    const path = '/v5/user/query-api';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const recvWindow = '5000';
    final signature = _createSignature(apiSecret, 'GET$path$timestamp$apiKey$recvWindow');

    _dio.options.headers = {
      'X-BAPI-API-KEY': apiKey,
      'X-BAPI-TIMESTAMP': timestamp,
      'X-BAPI-RECV-WINDOW': recvWindow,
      'X-BAPI-SIGN': signature,
    };

    try {
      final response = await _dio.get('$_baseUrl$path');
      // Handle response
    } catch (e) {
      // Handle error
    }
  }

  String _createSignature(String apiSecret, String data) {
    final hmac = Hmac(sha256, utf8.encode(apiSecret));
    final digest = hmac.convert(utf8.encode(data));
    return digest.toString();
  }
}