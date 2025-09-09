import 'package:activity_guide/shared/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomMetric extends StatefulWidget {
  final int quarter;
  final void Function(Map<String, String>)? onChanged;

  const CustomMetric({
    Key? key,
    required this.quarter,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomMetric> createState() => _CustomMetricState();
}

class _CustomMetricState extends State<CustomMetric> {
  late TextEditingController m1Controller, m2Controller, m3Controller, totalController;
  late TextEditingController c1Controller, c2Controller, c3Controller, ctController;
  late List<String> labels;

  @override
  void initState() {
    super.initState();
    labels = _getLabels(widget.quarter);

    m1Controller = TextEditingController();
    m2Controller = TextEditingController();
    m3Controller = TextEditingController();
    totalController = TextEditingController();

    c1Controller = TextEditingController();
    c2Controller = TextEditingController();
    c3Controller = TextEditingController();
    ctController = TextEditingController();

    m1Controller.addListener(_handleChange);
    m2Controller.addListener(_handleChange);
    m3Controller.addListener(_handleChange);
    c1Controller.addListener(_handleChange);
    c2Controller.addListener(_handleChange);
    c3Controller.addListener(_handleChange);
    ctController.addListener(_handleChange);

    _handleChange();
  }

  List<String> _getLabels(int quarter) {
    switch (quarter) {
      case 1:
        return ['Jan', 'Feb', 'Mar'];
      case 2:
        return ['Apr', 'May', 'Jun'];
      case 3:
        return ['Jul', 'Aug', 'Sep'];
      case 4:
        return ['Oct', 'Nov', 'Dec'];
      default:
        return ['M1', 'M2', 'M3'];
    }
  }

  void _handleChange() {
    final m1 = int.tryParse(m1Controller.text) ?? 0;
    final m2 = int.tryParse(m2Controller.text) ?? 0;
    final m3 = int.tryParse(m3Controller.text) ?? 0;
    final total = m1 + m2 + m3;

    final c1 = c1Controller.text;
    final c2 = c2Controller.text;
    final c3 = c3Controller.text;
    final ct = ctController.text;

    if (totalController.text != total.toString()) {
      totalController.text = total.toString();
    }

    widget.onChanged?.call({
      'm1': '$m1-$c1',
      'm2': '$m2-$c2',
      'm3': '$m3-$c3',
      't': '$total-$ct',
    });
  }

  @override
  void dispose() {
    m1Controller.dispose();
    m2Controller.dispose();
    m3Controller.dispose();
    totalController.dispose();
    c1Controller.dispose();
    c2Controller.dispose();
    c3Controller.dispose();
    ctController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _customLabel(label: labels[0], controller: m1Controller, commentController: c1Controller),
          const SizedBox(width: 8),
          _customLabel(label: labels[1], controller: m2Controller, commentController: c2Controller),
          const SizedBox(width: 8),
          _customLabel(label: labels[2], controller: m3Controller, commentController: c3Controller),
          const SizedBox(width: 8),
          _customLabel(
            label: 'Total',
            controller: totalController,
            commentController: ctController,
            readOnly: true,
          ),
        ],
      ),
    );
  }

  Widget _customLabel({
    required String label,
    required TextEditingController controller,
    required TextEditingController commentController,
    bool readOnly = false,
  }) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(label),
          const SizedBox(height: 4),
          SizedBox(
            width: 60,
            child: TextFormField(
              controller: controller,
              readOnly: readOnly,
              keyboardType: const TextInputType.numberWithOptions(),
              decoration: const InputDecoration(border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 100,
            child: TextFormField(
              controller: commentController,
              readOnly: readOnly && label == 'Total', // Optionally make total comment read-only
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Comment',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
