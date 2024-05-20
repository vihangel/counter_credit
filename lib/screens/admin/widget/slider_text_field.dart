import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SliderTextField extends StatefulWidget {
  final String labelText;
  final double min;
  final double max;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? unit;

  const SliderTextField({
    required this.labelText,
    required this.min,
    required this.max,
    required this.controller,
    this.validator,
    this.unit,
    this.keyboardType = const TextInputType.numberWithOptions(decimal: true),
    super.key,
  });

  @override
  SliderTextFieldState createState() => SliderTextFieldState();
}

class SliderTextFieldState extends State<SliderTextField> {
  late double _currentSliderValue;

  @override
  void initState() {
    super.initState();
    _currentSliderValue = double.tryParse(widget.controller.text) ?? widget.min;
    widget.controller.addListener(_updateSliderFromController);
  }

  void _updateSliderFromController() {
    double? newValue = double.tryParse(widget.controller.text);
    if (newValue != null && newValue >= widget.min && newValue <= widget.max) {
      if (_currentSliderValue != newValue) {
        setState(() {
          _currentSliderValue = newValue;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDecimal = widget.keyboardType ==
        const TextInputType.numberWithOptions(decimal: true);
    String decimalPattern = isDecimal ? r'^\d*\.?\d*' : r'^\d*';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              Expanded(
                child: Text(widget.labelText,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: TextFormField(
                  decoration: InputDecoration(
                    hintText: 'Digite um valor',
                    border: const OutlineInputBorder(),
                    suffixText: widget.unit,
                  ),
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(decimalPattern)),
                  ],
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: _currentSliderValue,
          min: widget.min,
          max: widget.max,
          divisions: isDecimal ? 100 : widget.max.toInt() - widget.min.toInt(),
          onChanged: (double value) {
            setState(() {
              _currentSliderValue = value;
              widget.controller.text = isDecimal
                  ? value.toStringAsFixed(2)
                  : value.toInt().toString();
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.min.toStringAsFixed(2),
                style: const TextStyle(color: Colors.grey)),
            Text(widget.max.toStringAsFixed(2),
                style: const TextStyle(color: Colors.grey)),
          ],
        )
      ],
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateSliderFromController);
    super.dispose();
  }
}
