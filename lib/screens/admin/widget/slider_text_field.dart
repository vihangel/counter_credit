import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class SliderTextField extends StatefulWidget {
  final String labelText;
  final double min;
  final double max;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final String? unit;
  final bool isDecimal;

  const SliderTextField({
    required this.labelText,
    required this.min,
    required this.max,
    required this.controller,
    this.isDecimal = false,
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
  final NumberFormat _numberFormat = NumberFormat.decimalPattern('pt_BR');

  @override
  void initState() {
    super.initState();
    _currentSliderValue = double.tryParse(widget.controller.text) ?? widget.min;
    widget.controller.text = _numberFormat.format(_currentSliderValue);
    // widget.controller.addListener(_updateSliderFromController);
  }

  void _updateSliderFromController() {
    double? newValue =
        double.tryParse(widget.controller.text.replaceAll(',', '.'));
    if (newValue != null && newValue >= widget.min && newValue <= widget.max) {
      if (_currentSliderValue != newValue) {
        setState(() {
          _currentSliderValue = newValue;
          widget.controller.text = _numberFormat.format(newValue);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,]')),
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      double newValue =
                          double.tryParse(value.replaceAll(',', '.')) ?? 0;
                      if (newValue >= widget.min && newValue <= widget.max) {
                        setState(() {
                          _currentSliderValue = newValue;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
        Slider(
          value: _currentSliderValue,
          min: widget.min,
          max: widget.max,
          divisions:
              widget.isDecimal ? 100 : widget.max.toInt() - widget.min.toInt(),
          onChanged: (double value) {
            if (widget.isDecimal) {
              widget.controller.text =
                  value.toStringAsFixed(2).replaceAll('.', ',');
            } else {
              widget.controller.text = value.toInt().toString();
            }
            setState(() {
              _currentSliderValue = value;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                widget.isDecimal
                    ? widget.min.toStringAsFixed(2).replaceAll('.', ',')
                    : widget.min.toInt().toString(),
                style: const TextStyle(color: Colors.grey)),
            Text(
                widget.isDecimal
                    ? widget.max.toStringAsFixed(2).replaceAll('.', ',')
                    : widget.max.toInt().toString(),
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
