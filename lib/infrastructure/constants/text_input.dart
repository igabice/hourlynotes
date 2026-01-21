import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/theme.dart';

enum KeyboardType { email, phone, number, text }

class AppAuthInput extends StatefulWidget {
  final String? hintText;
  final String? suffixText;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final void Function(String?)? onChanged;
  final VoidCallback? toggleEye;
  final KeyboardType? keyboard;
  final String? init;
  final bool isPassword;
  final Color? isPasswordColor;
  final bool? showObscureText;
  final bool obscureText;
  final Color? styleColor;
  final Color? borderColor;

  final Color? hintStyleColor;
  final bool enabled;
  final String? labelText;
  final double? labelTextFont;
  final dynamic maxLines;
  final Widget? prefix;
  final TextEditingController? controller;
  final List<TextInputFormatter>? inputFormatters;

  final bool isError;
  final String showErrorText;
  final Color enabledBorder;
  final Color focusedBorder;
  final Color labelTextColor;
  final Widget? suffix;
  final VoidCallback? onEditingComplete;
  final TextCapitalization? textCapitalization;
  final bool readOnly;
  final TextAlign? textAlign;

  const AppAuthInput({
    super.key,
    this.hintText,
    this.validator,
    this.onSaved,
    this.toggleEye,
    this.init,
    this.isPassword = false,
    this.isPasswordColor,
    this.showObscureText,
    this.obscureText = false,
    this.keyboard,
    this.styleColor,
    this.hintStyleColor,
    this.enabled = true,
    this.readOnly = false,
    this.labelText,
    this.labelTextFont,
    this.onEditingComplete,
    this.maxLines = 1,
    this.onChanged,
    this.prefix,
    this.suffix,
    this.suffixText,
    this.controller,
    this.inputFormatters,
    this.isError = false,
    this.textCapitalization,
    this.textAlign,
    this.borderColor,
    this.showErrorText = "field can't be empty",
    this.enabledBorder = const Color(0xFFDCE1E9),
    this.focusedBorder = const Color(0xFF1493A4),
    this.labelTextColor = const Color(0xFF202020),
  });

  @override
  State<AppAuthInput> createState() => _AppAuthInputState();
}

class _AppAuthInputState extends State<AppAuthInput> {
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      focusNode: _focusNode,
      textAlign: widget.textAlign ?? TextAlign.start,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      controller: widget.controller,
      enabled: widget.enabled,
      style: TextStyle(
        color: InvoysesTheme.theme.colorScheme.background == Colors.white
            ? const Color(0xFF5F5F5F)
            : const Color.fromARGB(255, 211, 209, 209),
        fontFamily: 'Figtree',
        fontWeight: FontWeight.w500,
        fontSize: 16,
      ),
      cursorColor: widget.styleColor,
      obscureText: widget.obscureText,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      onEditingComplete: widget.onEditingComplete,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.fromLTRB(25, 15, 10, 15),
        suffixText: widget.suffixText,
        hintText: widget.hintText,
        hintStyle:
            InvoysesTheme.theme.textTheme.bodyMedium!.copyWith(fontSize: 14),
        prefixIcon: widget.prefix,
        fillColor: InvoysesTheme.theme.colorScheme.background == Colors.white
            ? const Color.fromRGBO(245, 245, 245, 1)
            : const Color.fromRGBO(41, 41, 41, 1),
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        label: Text(
          widget.labelText ?? '',
          style: InvoysesTheme.theme.textTheme.bodyMedium!
              .copyWith(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        isDense: true,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: const BorderSide(color: Colors.red, width: 1),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(
                  color:
                      InvoysesTheme.theme.colorScheme.background != Colors.white
                          ? const Color.fromRGBO(245, 245, 245, 1)
                          : const Color.fromRGBO(41, 41, 41, 1),
                  width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(
                  color:
                      InvoysesTheme.theme.colorScheme.background != Colors.white
                          ? const Color.fromRGBO(245, 245, 245, 1)
                          : const Color.fromRGBO(41, 41, 41, 1),
                  width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(
                  color:
                      InvoysesTheme.theme.colorScheme.background != Colors.white
                          ? const Color.fromRGBO(245, 245, 245, 1)
                          : const Color.fromRGBO(41, 41, 41, 1),
                  width: 1),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: widget.borderColor != null
              ? BorderSide(color: widget.borderColor!, width: 1)
              : BorderSide(
                  color:
                      InvoysesTheme.theme.colorScheme.background != Colors.white
                          ? const Color.fromRGBO(245, 245, 245, 1)
                          : const Color.fromRGBO(41, 41, 41, 1),
                  width: 1),
        ),
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: widget.toggleEye,
                child: Icon(
                  widget.showObscureText!
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: InvoysesTheme.theme.colorScheme.tertiary,
                ),
              )
            : widget.suffix,
      ),
      validator: widget.validator,
      initialValue: widget.init,
      onSaved: widget.onSaved,
      keyboardType: _getKeyboardType(),
    );
  }

  TextInputType _getKeyboardType() {
    switch (widget.keyboard) {
      case KeyboardType.email:
        return TextInputType.emailAddress;
      case KeyboardType.number:
        return const TextInputType.numberWithOptions(decimal: true);
      case KeyboardType.phone:
        return TextInputType.phone;
      default:
        return TextInputType.text;
    }
  }
}
