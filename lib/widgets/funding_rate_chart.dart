import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:frwin/models/funding_rate_data.dart';
import 'package:intl/intl.dart';

enum TimeRange { oneDay, sevenDays, oneMonth, threeMonths, all }

class FundingRateChart extends StatefulWidget {
  final List<FundingRateData> fundingRateHistory;

  const FundingRateChart({super.key, required this.fundingRateHistory});

  @override
  State<FundingRateChart> createState() => _FundingRateChartState();
}

class _FundingRateChartState extends State<FundingRateChart> {
  TimeRange _selectedTimeRange = TimeRange.sevenDays;
  bool _showVolume = true;
  bool _showPrice = true;
  late ZoomPanBehavior _zoomPanBehavior;
  late TrackballBehavior _trackballBehavior;

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true,
      enablePanning: true,
      zoomMode: ZoomMode.x,
    );
    _trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
      tooltipSettings: const InteractiveTooltip(
        enable: true,
        format: 'point.x : point.y',
      ),
    );
  }

  List<FundingRateData> get _filteredData {
    final now = DateTime.now();
    switch (_selectedTimeRange) {
      case TimeRange.oneDay:
        return widget.fundingRateHistory
            .where((d) => d.timestamp.isAfter(now.subtract(const Duration(days: 1))))
            .toList();
      case TimeRange.sevenDays:
        return widget.fundingRateHistory
            .where((d) => d.timestamp.isAfter(now.subtract(const Duration(days: 7))))
            .toList();
      case TimeRange.oneMonth:
        return widget.fundingRateHistory
            .where((d) => d.timestamp.isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      case TimeRange.threeMonths:
        return widget.fundingRateHistory
            .where((d) => d.timestamp.isAfter(now.subtract(const Duration(days: 90))))
            .toList();
      case TimeRange.all:
      default:
        return widget.fundingRateHistory;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimeRangeSelector(),
        Expanded(
          child: SfCartesianChart(
            primaryXAxis: DateTimeAxis(
              edgeLabelPlacement: EdgeLabelPlacement.shift,
              dateFormat: DateFormat.MMMd(),
              intervalType: DateTimeIntervalType.days,
              majorGridLines: const MajorGridLines(width: 0),
            ),
            primaryYAxis: NumericAxis(
              name: 'fundingRate',
              labelFormat: '{value}%',
              axisLine: const AxisLine(width: 0),
              majorTickLines: const MajorTickLines(size: 0),
            ),
            series: _getSeries(),
            zoomPanBehavior: _zoomPanBehavior,
            trackballBehavior: _trackballBehavior,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeRangeSelector() {
    return SegmentedButton<TimeRange>(
      segments: const [
        ButtonSegment(value: TimeRange.oneDay, label: Text('1D')),
        ButtonSegment(value: TimeRange.sevenDays, label: Text('7D')),
        ButtonSegment(value: TimeRange.oneMonth, label: Text('1M')),
        ButtonSegment(value: TimeRange.threeMonths, label: Text('3M')),
        ButtonSegment(value: TimeRange.all, label: Text('All')),
      ],
      selected: {_selectedTimeRange},
      onSelectionChanged: (Set<TimeRange> newSelection) {
        setState(() {
          _selectedTimeRange = newSelection.first;
        });
      },
    );
  }


  List<CartesianSeries<FundingRateData, DateTime>> _getSeries() {
    final data = _aggregateData(_filteredData);
    final List<CartesianSeries<FundingRateData, DateTime>> series = [
      ColumnSeries<FundingRateData, DateTime>(
        dataSource: data,
        xValueMapper: (FundingRateData rate, _) => rate.timestamp,
        yValueMapper: (FundingRateData rate, _) => rate.fundingRate * 100,
        pointColorMapper: (FundingRateData rate, _) =>
            rate.fundingRate >= 0 ? Colors.green : Colors.red,
        name: 'Funding Rate',
        yAxisName: 'fundingRate',
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        enableTooltip: true,
      ),
    ];


    return series;
  }

  List<FundingRateData> _aggregateData(List<FundingRateData> data) {
    if (data.length <= 200) {
      return data;
    }

    final List<FundingRateData> aggregatedData = [];
    final int aggregationFactor = (data.length / 100).ceil();

    for (int i = 0; i < data.length; i += aggregationFactor) {
      final int end = (i + aggregationFactor < data.length) ? i + aggregationFactor : data.length;
      final List<FundingRateData> chunk = data.sublist(i, end);
      
      if (chunk.isNotEmpty) {
        final double avgRate =
            chunk.map((d) => d.fundingRate).reduce((a, b) => a + b) /
                chunk.length;
        final DateTime midTimestamp = chunk[chunk.length ~/ 2].timestamp;
        final String symbol = chunk.first.symbol;

        aggregatedData.add(FundingRateData(
          symbol: symbol,
          fundingRate: avgRate,
          timestamp: midTimestamp,
        ));
      }
    }
    return aggregatedData;
  }
}