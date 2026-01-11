class FundingRateData {
  final String symbol;
  final double fundingRate;
  final DateTime timestamp;

  FundingRateData({
    required this.symbol,
    required this.fundingRate,
    required this.timestamp,
  });
}