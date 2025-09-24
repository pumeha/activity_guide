import 'package:activity_guide/shared/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/constants.dart';
import 'app_text.dart';

class CustomDropdown extends StatelessWidget {
  final String labelText;
  final String? selectedItem;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final bool outsideLabel;
  final bool currency;

  const CustomDropdown({
    Key? key,
    required this.labelText,
    required this.selectedItem,
    required this.items,
    required this.onChanged,
    this.outsideLabel = true,
    this.currency = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return outsideLabel
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(text: labelText),
              const SizedBox(height: 8),
              _buildDropdown(),
            ],
          )
        : _buildDropdown();
  }

  Widget _buildDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: outsideLabel ? null : labelText,
        fillColor: Colors.white30,
        filled: true,
      ),
      value: selectedItem,
      icon: Icon(Icons.arrow_drop_down_circle),

      iconEnabledColor: active,
      isExpanded:
          true, // prevents text overflow :contentReference[oaicite:0]{index=0}
      items: items
          .map(
            (v) => DropdownMenuItem(
              value: v,
              child: AppText(text: v, currency: currency),
            ),
          ).toList(),
      onChanged: onChanged,
      validator: validatorFunction,
    );
  }
}
