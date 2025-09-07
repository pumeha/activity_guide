import 'package:flutter/material.dart';
class CustomMetric extends StatefulWidget {
  final int quarter;
  final void Function(Map<String, int>)? onChanged; // ← Callback

  const CustomMetric({
    Key? key,
    required this.quarter,
    this.onChanged,
  }) : super(key: key);

  @override
  State<CustomMetric> createState() => _CustomMetricState();
}

class _CustomMetricState extends State<CustomMetric> {
  late TextEditingController m1Controller;
  late TextEditingController m2Controller;
  late TextEditingController m3Controller;
  late TextEditingController totalController;
  late List<String> labels;

  @override
  void initState() {
    super.initState();
    labels = _getLabels(widget.quarter);
    m1Controller = TextEditingController();
    m2Controller = TextEditingController();
    m3Controller = TextEditingController();
    totalController = TextEditingController();

    m1Controller.addListener(_handleChange);
    m2Controller.addListener(_handleChange);
    m3Controller.addListener(_handleChange);

    _handleChange(); // initialize total
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

    // update total field
    totalController.text = total.toString();

    // call the onChanged callback with the data
    widget.onChanged?.call({
      'm1': m1,
      'm2': m2,
      'm3': m3,
      't': total,
    });
  }

  @override
  void dispose() {
    m1Controller.dispose();
    m2Controller.dispose();
    m3Controller.dispose();
    totalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _customLabel(label: labels[0], child: _textField(m1Controller)),
        const SizedBox(width: 8),
        _customLabel(label: labels[1], child: _textField(m2Controller)),
        const SizedBox(width: 8),
        _customLabel(label: labels[2], child: _textField(m3Controller)),
        const SizedBox(width: 8),
        _customLabel(
          label: 'Total',
          child: TextFormField(
            controller: totalController,
            readOnly: true,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ),
      ],
    );
  }

  Widget _customLabel({required String label, required Widget child}) {
    return Column(
      children: [
        Text(label),
        const SizedBox(height: 4),
        SizedBox(width: 60, child: child),
      ],
    );
  }

  Widget _textField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(),
      decoration: const InputDecoration(border: OutlineInputBorder()),
    );
  }
}
