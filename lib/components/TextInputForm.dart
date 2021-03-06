import 'package:flutter/material.dart';
import 'package:gest_inventory/utils/icons.dart';
import '../utils/colors.dart';

class TextInputForm extends StatelessWidget {
  final void Function() onTap;
  final void Function(String)? onChange;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final bool readOnly;
  final TextEditingController controller;
  final TextInputType inputType;
  final bool passwordTextStatus;
  final String? errorText;

  TextInputForm({
    Key? key,
    required this.onTap,
    this.onChange,
    this.hintText,
    this.labelText,
    this.helperText,
    required this.controller,
    required this.inputType,
    this.errorText,
    this.readOnly = false,
    this.passwordTextStatus = false,
  }) : super(key: key);

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: primaryColor),
  );

  final _errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.red),
  );

  final _textStyle = TextStyle(
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
      child: TextFormField(
        keyboardType: inputType,
        controller: controller,
        style: _textStyle,
        onChanged: onChange,
        obscureText: passwordTextStatus,
        decoration: InputDecoration(
          isDense: true,
          errorText: errorText,
          labelText: labelText,
          hintText: hintText,
          helperText: helperText,
          enabledBorder: _border,
          focusedBorder: _border,
          errorBorder: _errorBorder,
          border: _border,
          labelStyle: const TextStyle(
            color: primaryColor,
          ),
          suffixIcon: inputType == TextInputType.visiblePassword
              ? InkWell(
                  onTap: onTap,
                  child: passwordTextStatus
                      ? getIcon(AppIcons.hide, color: primaryColor)
                      : getIcon(AppIcons.show, color: primaryColor),
                )
              : null,
        ),
      ),
    );
  }
}
