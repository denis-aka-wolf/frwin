import 'package:flutter/material.dart';

class FilterControls extends StatelessWidget {
  const FilterControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child:
                // TODO: Implement instrument dropdown
                Text('Instrument Dropdown'),
          ),
          IconButton(
            icon: Icon(Icons.date_range),
            onPressed: () {
              // TODO: Implement date range picker
            },
          ),
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              // TODO: Implement refresh logic
            },
          ),
        ],
      ),
    );
  }
}