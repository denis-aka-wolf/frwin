import 'package:flutter/material.dart';

class FundingRateDetailScreen extends StatelessWidget {
  const FundingRateDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instrument Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // TODO: Display current funding rate value
            // TODO: Show next funding time
            // TODO: Display instrument price
            // TODO: Show trading volumes
            const SizedBox(height: 20),
            // TODO: Include the chart visualization area
            Expanded(
              child: Center(
                child: Text('Chart will be displayed here'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}