import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frwin/models/api_response.dart';
import 'package:frwin/models/funding_rate_data.dart';
import 'package:frwin/models/instrument_info.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';

@lazySingleton
class BybitApiService {
  final Dio _dio;
  final FlutterSecureStorage _secureStorage;
  final _logger = Logger();

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

  Future<ApiResponse<InstrumentInfo>> getInstrumentsInfo(String category, {String? cursor}) async {
    final url = '$_baseUrl/v5/market/instruments-info';
    final params = {'category': category, 'cursor': cursor, 'limit': 100};
    _logger.i('Fetching instruments info from: $url with params: $params');
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['retCode'] == 0) {
        final result = response.data['result'];
        final List<dynamic> instrumentList = result['list'];
        final instruments = instrumentList
            .map((json) => InstrumentInfo(
                  symbol: json['symbol'],
                  baseCurrency: json['baseCoin'],
                  quoteCurrency: json['quoteCoin'],
                ))
            .toList();
        _logger.i('Successfully fetched and parsed ${instruments.length} instruments.');
        return ApiResponse<InstrumentInfo>(
          list: instruments,
          nextPageCursor: result['nextPageCursor'],
        );
      } else {
        _logger.e('Failed to load instrument info: ${response.data['retMsg']}');
        throw Exception(
            'Failed to load instrument info: ${response.data['retMsg']}');
      }
    } catch (e) {
      _logger.e('Failed to load instrument info: $e');
      throw Exception('Failed to load instrument info: $e');
    }
  }

  Future<List<FundingRateData>> getFundingRateHistory(
      String category, String symbol, {int? limit}) async {
    final url = '$_baseUrl/v5/market/funding/history';
    final params = {
      'category': category,
      'symbol': symbol,
      'limit': limit ?? 200,
    };
    _logger.i('Fetching funding rate history from: $url with params: $params');
    try {
      final response = await _dio.get(
        url,
        queryParameters: params,
      );

      _logger.d('Response status: ${response.statusCode}');
      _logger.d('Response data: ${response.data}');

      if (response.statusCode == 200 && response.data['retCode'] == 0) {
        final List<dynamic> historyList = response.data['result']['list'];
        final result = historyList
            .map((json) => FundingRateData(
                  symbol: json['symbol'],
                  fundingRate: double.parse(json['fundingRate']),
                  timestamp: DateTime.fromMillisecondsSinceEpoch(
                      int.parse(json['fundingRateTimestamp'])),
                ))
            .toList();
        _logger.i(
            'Successfully fetched and parsed ${result.length} funding rate data points.');
        return result;
      } else {
        _logger.e(
            'Failed to load funding rate history: ${response.data['retMsg']}');
        throw Exception(
            'Failed to load funding rate history: ${response.data['retMsg']}');
      }
    } catch (e) {
      _logger.e('Failed to load funding rate history: $e');
      throw Exception('Failed to load funding rate history: $e');
    }
  }

  // Placeholder for a method that might require authentication
  Future<void> getAccountInfo() async {
    _logger.i('Attempting to get account info.');
    final apiKey = await _secureStorage.read(key: _apiKeyStore);
    final apiSecret = await _secureStorage.read(key: _apiSecretStore);

    if (apiKey == null || apiSecret == null) {
      _logger.w('API credentials not set.');
      throw Exception('API credentials not set.');
    }
    _logger.d('API credentials found.');

    const path = '/v5/user/query-api';
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    const recvWindow = '5000';
    final toSign = 'GET$path$timestamp$apiKey$recvWindow';
    final signature = _createSignature(apiSecret, toSign);
    _logger.d('Signature created for data: $toSign');


    _dio.options.headers = {
      'X-BAPI-API-KEY': apiKey,
      'X-BAPI-TIMESTAMP': timestamp,
      'X-BAPI-RECV-WINDOW': recvWindow,
      'X-BAPI-SIGN': signature,
    };

    _logger.i('Requesting account info from: $_baseUrl$path');
    try {
      final response = await _dio.get('$_baseUrl$path');
      _logger.d('Account info response status: ${response.statusCode}');
      _logger.d('Account info response data: ${response.data}');
      // Handle response
    } catch (e) {
      _logger.e('Failed to get account info: $e');
      // Handle error
    }
  }

  String _createSignature(String apiSecret, String data) {
    final hmac = Hmac(sha256, utf8.encode(apiSecret));
    final digest = hmac.convert(utf8.encode(data));
    return digest.toString();
  }
}