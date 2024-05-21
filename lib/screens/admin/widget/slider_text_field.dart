import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

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
  final NumberFormat _numberFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: '', decimalDigits: 2);

  final maskFormatter = MaskTextInputFormatter(
    mask: '###.###.###,##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.lazy,
  );

  @override
  void initState() {
    super.initState();
    _currentSliderValue = double.tryParse(
            widget.controller.text.replaceAll('.', '').replaceAll(',', '.')) ??
        widget.min;
    widget.controller.text =
        widget.isDecimal ? _formatCurrency(_currentSliderValue) : "0";
    widget.controller.addListener(_updateSliderFromController);
  }

  void _updateSliderFromController() {
    double? newValue = double.tryParse(
        widget.controller.text.replaceAll('.', '').replaceAll(',', '.'));
    if (newValue != null && newValue >= widget.min && newValue <= widget.max) {
      if (_currentSliderValue != newValue) {
        setState(() {
          _currentSliderValue = newValue;
        });
      }
    }
  }

  String _formatCurrency(double value) {
    return _numberFormat.format(value);
  }

  String _formatInput(String input) {
    double? parsedValue =
        double.tryParse(input.replaceAll('.', '').replaceAll(',', '.'));
    if (parsedValue != null) {
      return _numberFormat.format(parsedValue);
    }
    return input;
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
                    errorStyle: const TextStyle(overflow: TextOverflow.visible),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: widget.controller,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  inputFormatters: widget.isDecimal ? [maskFormatter] : null,
                  onFieldSubmitted: (value) {
                    setState(() {
                      widget.controller.text = _formatInput(value);
                    });
                  },
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      if (widget.isDecimal) {
                        double newValue = double.tryParse(value
                                .replaceAll('.', '')
                                .replaceAll(',', '.')) ??
                            0;
                        if (newValue >= widget.min && newValue <= widget.max) {
                          setState(() {
                            _currentSliderValue = newValue;
                          });
                        }

                        widget.controller.text = _formatInput(value);

                        widget.controller.selection =
                            TextSelection.fromPosition(
                          TextPosition(offset: widget.controller.text.length),
                        );
                      } else {
                        int newValue = int.tryParse(value) ?? 0;
                        if (newValue >= widget.min && newValue <= widget.max) {
                          setState(() {
                            _currentSliderValue = newValue.toDouble();
                          });
                        }
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
            widget.controller.text = widget.isDecimal
                ? _formatCurrency(value)
                : value.toInt().toString();
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
                    ? _formatCurrency(widget.min)
                    : widget.min.toInt().toString(),
                style: const TextStyle(color: Colors.grey)),
            Text(
                widget.isDecimal
                    ? _formatCurrency(widget.max)
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
