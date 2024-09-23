import 'package:flutter/material.dart';

import '../../tools/app_colours.dart';

class ButtonComponent extends StatefulWidget {
  final String label;
  final Widget? icon;
  final ButtonType type;
  final Function() onPressed;
  final bool isLoading;
  const ButtonComponent(
      {super.key,
        required this.label,
        this.icon,
        this.type = ButtonType.primary,
        required this.onPressed,  this.isLoading = false});

  @override
  State<ButtonComponent> createState() => _ButtonComponentState();
}

class _ButtonComponentState extends State<ButtonComponent> {
  final Map<ButtonType, Color> backgroundColor = {
    ButtonType.primary: AppColours.primaryColor,
    ButtonType.secondary: AppColours.primaryColor2,
    ButtonType.ligth: Colors.white,
  };

  final Map<ButtonType, Color> foregroundColor = {
    ButtonType.primary: Colors.white,
    ButtonType.secondary: Colors.white,
    ButtonType.ligth: Colors.black,
  };

  final Map<ButtonType, Color> borderColor = {
    ButtonType.primary: Colors.white,
    ButtonType.secondary: Colors.white,
    ButtonType.ligth: AppColours.primaryColorlight.withOpacity(0.5),
  };

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: 56,
        child: ElevatedButton(
          onPressed: widget.onPressed,
          child: widget.isLoading ? CircularProgressIndicator(color: AppColours.success,) : Text(widget.label),
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape:RoundedRectangleBorder(
                side: BorderSide(color: borderColor[widget.type]!),
                borderRadius: BorderRadius.circular(16)),
            foregroundColor: foregroundColor[widget.type],
            backgroundColor: backgroundColor[widget.type],
          ),
        )
    );
  }
}

enum ButtonType {
  primary,
  secondary,
  ligth,
}
