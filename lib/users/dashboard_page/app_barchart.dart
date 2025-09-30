import 'package:flutter/material.dart';
import 'package:activity_guide/users/dashboard_page/custom_dashboard_page.dart';

class AppBarchart extends StatelessWidget {
  AppBarchart({super.key, required this.data, required this.top, required this.title});

  final bool top;
  final String title;
  final List<ActivityAndValues> data;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade600, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title at center
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),

          // Chart Items
          if (data.isNotEmpty)
            ...data.map(
                  (e) => _body(
                output: e.output,
                value: e.percentCompleted.toString(),
              ),
            )
          else
            const Text("No data available"),
        ],
      ),
    );
  }

  Widget _body({required String output, required String value}) {
    return SizedBox(
      width: 300,
      child: Card(
        color: top ? Colors.teal : Colors.red,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    output.trimLeft(),
                    softWrap: true,
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.black,
                padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                child: Center(
                  child: Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
