import 'package:flutter/material.dart';

import '../../tools/app_colours.dart';
import '../../tools/app_spacing.dart';


class CheckboxInputComponent extends StatefulWidget {
  final bool value;
  final Widget? label;
  final ValueChanged<bool> onChanged;
  const CheckboxInputComponent(
      {super.key, required this.value, required this.onChanged, this.label});

  @override
  State<CheckboxInputComponent> createState() => _CheckboxInputComponentState();
}

class _CheckboxInputComponentState extends State<CheckboxInputComponent> {
  late bool value;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.5,
          child:  Checkbox(
              activeColor: AppColours.primaryColor,
              checkColor: Colors.white,
              value: value,
              onChanged: (bool? newValue){
                setState(() => value = newValue!);
                widget.onChanged(value);
              }),
        ),
        if(widget.label != null)...[
          AppSpacing.horizontal(size: 4),
          Expanded(
              child: widget.label!
          )
        ]
      ],
    );
  }

  @override
  void initState() {
    value = widget.value;
    super.initState();
  }
}
