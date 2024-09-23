import 'package:flutter/material.dart';

import '../../tools/app_colours.dart';
import '../../tools/app_spacing.dart';


class TextInputComponent extends StatefulWidget {
  final bool isRequired;
  final bool isEnabled;
  final String label;
  final String? error;
  final bool isPassword;
  final ValueChanged<String> ? onFielSubmitted;
  final TextEditingController textEditingController;
  final TextInputAction ? textInputAction;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final ValueChanged<String> ? onChanged;

  const TextInputComponent(
      {super.key,
        required this.label,
        this.isPassword = false,
        required this.textEditingController,
        this.onFielSubmitted,
        required this.textInputAction,
        this.focusNode, this.textInputType, this.isRequired = false, this.isEnabled = true, this.error, this.onChanged});

  @override
  State<TextInputComponent> createState() => _TextInputComponentState();
}

class _TextInputComponentState extends State<TextInputComponent> {
  bool showpassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.textEditingController,
      enabled: widget.isEnabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (!widget.isRequired) return null;
        if (value == null || value.isEmpty) {
          return "Ce champ est requis, veuillez le remplir";
        }
        return null;
      },
      focusNode: widget.focusNode,
      obscureText: (widget.isPassword && !showpassword),
      onFieldSubmitted: widget.onFielSubmitted,
      onChanged: widget.onChanged,  // Ajoute cette ligne
      keyboardType: widget.textInputType,
      textInputAction: widget.textInputAction ?? TextInputAction.next,
      decoration: InputDecoration(
        labelText: widget.label,
        errorText: widget.error,
        labelStyle: TextStyle(color: AppColours.primaryColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColours.primaryColorlight.withOpacity(0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(
            color: AppColours.primaryColorlight.withOpacity(0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: AppColours.primaryColor),
        ),
        suffixIcon: widget.isPassword
            ? IconButton(
          onPressed: togglePassword,
          icon: Icon(
            showpassword ? Icons.visibility_off_rounded : Icons.visibility_rounded,
            color: AppColours.primaryColor,
          ),
        )
            : AppSpacing.empty(),
      ),
    );
  }


  void togglePassword() => setState(() {
    showpassword = !showpassword;
  });
}
