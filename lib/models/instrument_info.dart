class InstrumentInfo {
  final String symbol;
  final String contractType;
  final String status;
  final String baseCoin;
  final String quoteCoin;
  final String launchTime;
  final String deliveryTime;
  final String deliveryFeeRate;
  final String priceScale;
  final LeverageFilter leverageFilter;
  final PriceFilter priceFilter;
  final LotSizeFilter lotSizeFilter;
  final bool unifiedMarginTrade;
  final int fundingInterval;
  final String settleCoin;
  final String copyTrading;
  final String upperFundingRate;
  final String lowerFundingRate;

  InstrumentInfo({
    required this.symbol,
    required this.contractType,
    required this.status,
    required this.baseCoin,
    required this.quoteCoin,
    required this.launchTime,
    required this.deliveryTime,
    required this.deliveryFeeRate,
    required this.priceScale,
    required this.leverageFilter,
    required this.priceFilter,
    required this.lotSizeFilter,
    required this.unifiedMarginTrade,
    required this.fundingInterval,
    required this.settleCoin,
    required this.copyTrading,
    required this.upperFundingRate,
    required this.lowerFundingRate,
  });

  factory InstrumentInfo.fromJson(Map<String, dynamic> json) {
    return InstrumentInfo(
      symbol: json['symbol'],
      contractType: json['contractType'],
      status: json['status'],
      baseCoin: json['baseCoin'],
      quoteCoin: json['quoteCoin'],
      launchTime: json['launchTime'],
      deliveryTime: json['deliveryTime'],
      deliveryFeeRate: json['deliveryFeeRate'],
      priceScale: json['priceScale'],
      leverageFilter: LeverageFilter.fromJson(json['leverageFilter']),
      priceFilter: PriceFilter.fromJson(json['priceFilter']),
      lotSizeFilter: LotSizeFilter.fromJson(json['lotSizeFilter']),
      unifiedMarginTrade: json['unifiedMarginTrade'],
      fundingInterval: json['fundingInterval'],
      settleCoin: json['settleCoin'],
      copyTrading: json['copyTrading'],
      upperFundingRate: json['upperFundingRate'],
      lowerFundingRate: json['lowerFundingRate'],
    );
  }
}

class LeverageFilter {
  final String minLeverage;
  final String maxLeverage;
  final String leverageStep;

  LeverageFilter({
    required this.minLeverage,
    required this.maxLeverage,
    required this.leverageStep,
  });

  factory LeverageFilter.fromJson(Map<String, dynamic> json) {
    return LeverageFilter(
      minLeverage: json['minLeverage'],
      maxLeverage: json['maxLeverage'],
      leverageStep: json['leverageStep'],
    );
  }
}

class PriceFilter {
  final String minPrice;
  final String maxPrice;
  final String tickSize;

  PriceFilter({
    required this.minPrice,
    required this.maxPrice,
    required this.tickSize,
  });

  factory PriceFilter.fromJson(Map<String, dynamic> json) {
    return PriceFilter(
      minPrice: json['minPrice'],
      maxPrice: json['maxPrice'],
      tickSize: json['tickSize'],
    );
  }
}

class LotSizeFilter {
  final String maxOrderQty;
  final String minOrderQty;
  final String qtyStep;
  final String postOnlyMaxOrderQty;
  final String maxMktOrderQty;
  final String minNotionalValue;

  LotSizeFilter({
    required this.maxOrderQty,
    required this.minOrderQty,
    required this.qtyStep,
    required this.postOnlyMaxOrderQty,
    required this.maxMktOrderQty,
    required this.minNotionalValue,
  });

  factory LotSizeFilter.fromJson(Map<String, dynamic> json) {
    return LotSizeFilter(
      maxOrderQty: json['maxOrderQty'],
      minOrderQty: json['minOrderQty'],
      qtyStep: json['qtyStep'],
      postOnlyMaxOrderQty: json['postOnlyMaxOrderQty'],
      maxMktOrderQty: json['maxMktOrderQty'],
      minNotionalValue: json['minNotionalValue'],
    );
  }
}