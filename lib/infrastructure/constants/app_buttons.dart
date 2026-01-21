// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import '../theme/theme.dart';

// ignore: must_be_immutable
class AppAuthButton extends StatefulWidget {
  final void Function()? onPressed;
  final String buttonText;
  final Color? textColor;
  final bool isLoading;
  final bool hasLeading;
  final Widget? leading;
  final ButtonStyle? style;
  final bool enabled;
  final Color? borderColor;

  const AppAuthButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.textColor,
    this.isLoading = false,
    this.hasLeading = false,
    this.style,
    this.leading,
    this.enabled = true, // default is enabled
    this.borderColor,
  });

  @override
  State<AppAuthButton> createState() => _AppAuthButtonState();
}

class _AppAuthButtonState extends State<AppAuthButton> {
  @override
  Widget build(BuildContext context) {
    final isDisabled = !widget.enabled || widget.isLoading;

    return Container(
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: 1.0)
            : null,
      ),
      child: ElevatedButton(
        onPressed: isDisabled ? null : widget.onPressed,
        style: widget.style ??
            InvoysesTheme.theme.elevatedButtonTheme.style!.copyWith(
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (isDisabled) {
                  return InvoysesTheme.theme.colorScheme.primary
                      .withOpacity(0.3);
                }
                return InvoysesTheme.theme.colorScheme.primary;
              }),
            ),
        child: Center(
          child: widget.isLoading
              ? SizedBox(
                  height: 10,
                  width: 10,
                  child: CircularProgressIndicator.adaptive(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation(
                      InvoysesTheme.theme.colorScheme.surface,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.hasLeading) widget.leading!,
                    if (widget.hasLeading) const SizedBox(width: 10),
                    Text(
                      widget.buttonText,
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Figtree',
                        color: widget.textColor ??
                            (isDisabled ? Colors.grey.shade300 : Colors.white),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AppSecondaryAuthButton extends StatefulWidget {
  void Function()? onPressed;
  final String buttonText;
  final Color? textColor;
  final bool isLoading;
  final bool isEnabled;
  final bool hasLeading;
  final Widget? leading;
  final ButtonStyle? style;
  AppSecondaryAuthButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.textColor,
      this.isLoading = false,
      this.isEnabled = true,
      this.hasLeading = false,
      this.style,
      this.leading});

  @override
  State<AppSecondaryAuthButton> createState() => _AppSecondaryAuthButtonState();
}

class _AppSecondaryAuthButtonState extends State<AppSecondaryAuthButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      // width: MediaQuery.sizeOf(context).width * 282 / 375,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.style ??
              InvoysesTheme.theme.elevatedButtonTheme.style!.copyWith(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor: WidgetStateColor.resolveWith((states) =>
                      widget.isLoading
                          ? InvoysesTheme.theme.colorScheme.primary
                              .withOpacity(0.3)
                          : widget.isEnabled == false
                              ? InvoysesTheme.theme.colorScheme.primary
                                  .withOpacity(0.1)
                              : InvoysesTheme.theme.colorScheme.primary)),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                          InvoysesTheme.theme.colorScheme.surface),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.hasLeading ? widget.leading! : const SizedBox(),
                      widget.hasLeading
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      Text(
                        widget.buttonText,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            color: widget.textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
          )),
    );
  }
}

// ignore: must_be_immutable
class AppAuthOutlineButton extends StatefulWidget {
  void Function()? onPressed;
  final String buttonText;
  final Color? buttonTextColor;
  final Color? buttonBorderColor;
  final ButtonStyle? buttonStyle;
  final bool hasLeading;
  final Widget? leading;
  AppAuthOutlineButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.buttonTextColor,
    this.buttonBorderColor,
    this.buttonStyle,
    this.hasLeading = false,
    this.leading,
  });

  @override
  State<AppAuthOutlineButton> createState() => _AppAuthOutlineButtonState();
}

class _AppAuthOutlineButtonState extends State<AppAuthOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: InvoysesTheme.theme.colorScheme.tertiary)),
      child: OutlinedButton(
        clipBehavior: Clip.hardEdge,
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.hasLeading) widget.leading!,
            if (widget.hasLeading) const SizedBox(width: 10),
            Text(
              widget.buttonText,
              style: TextStyle(
                  color: widget.buttonTextColor ?? Colors.black,
                  fontSize: 16,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AppAuthDeleteButton extends StatefulWidget {
  void Function()? onPressed;
  final String buttonText;
  final Color? textColor;
  final bool isLoading;
  final bool hasLeading;
  final Widget? leading;
  final ButtonStyle? style;
  AppAuthDeleteButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      this.textColor,
      this.isLoading = false,
      this.hasLeading = false,
      this.style,
      this.leading});

  @override
  State<AppAuthDeleteButton> createState() => _AppAuthDeleteButtonState();
}

class _AppAuthDeleteButtonState extends State<AppAuthDeleteButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(40)),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.style ??
              InvoysesTheme.theme.elevatedButtonTheme.style!.copyWith(
                  backgroundColor: WidgetStateColor.resolveWith((states) =>
                      widget.isLoading
                          ? InvoysesTheme.errorColor.withOpacity(0.3)
                          : InvoysesTheme.errorColor)),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                          InvoysesTheme.theme.colorScheme.surface),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.hasLeading ? widget.leading! : const SizedBox(),
                      widget.hasLeading
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      Text(
                        widget.buttonText,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            color: widget.textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
          )),
    );
  }
}

// ignore: must_be_immutable
class AppAuthSecondaryOutlineButton extends StatefulWidget {
  void Function()? onPressed;
  final String buttonText;
  final Color? buttonTextColor;
  final Color? buttonBorderColor;
  final ButtonStyle? buttonStyle;
  final bool hasLeading;
  final Widget? leading;
  AppAuthSecondaryOutlineButton({
    super.key,
    this.onPressed,
    required this.buttonText,
    this.buttonTextColor,
    this.buttonBorderColor,
    this.buttonStyle,
    this.hasLeading = false,
    this.leading,
  });

  @override
  State<AppAuthSecondaryOutlineButton> createState() =>
      _AppAuthSecondaryOutlineButtonState();
}

class _AppAuthSecondaryOutlineButtonState
    extends State<AppAuthSecondaryOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: InvoysesTheme.theme.colorScheme.tertiary)),
      child: OutlinedButton(
        clipBehavior: Clip.hardEdge,
        onPressed: widget.onPressed,
        style: widget.buttonStyle ??
            ButtonStyle(
                shape: WidgetStatePropertyAll<OutlinedBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (widget.hasLeading) widget.leading!,
            if (widget.hasLeading) const SizedBox(width: 10),
            Text(
              widget.buttonText,
              style: TextStyle(
                  color: widget.buttonTextColor ?? Colors.black,
                  fontSize: 16,
                  fontFamily: 'Figtree',
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class AppTertiaryAuthButton extends StatefulWidget {
  void Function()? onPressed;
  final String buttonText;
  final Color? textColor;
  final Color? buttonColor;
  final bool isLoading;
  final bool isEnabled;
  final bool hasLeading;
  final Widget? leading;
  final ButtonStyle? style;
  AppTertiaryAuthButton(
      {super.key,
      this.onPressed,
      required this.buttonText,
      required this.buttonColor,
      this.textColor,
      this.isLoading = false,
      this.isEnabled = true,
      this.hasLeading = false,
      this.style,
      this.leading});

  @override
  State<AppTertiaryAuthButton> createState() => _AppTertiaryAuthButtonState();
}

class _AppTertiaryAuthButtonState extends State<AppTertiaryAuthButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      // width: MediaQuery.sizeOf(context).width * 282 / 375,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: ElevatedButton(
          onPressed: widget.onPressed,
          style: widget.style ??
              InvoysesTheme.theme.elevatedButtonTheme.style!.copyWith(
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5))),
                  backgroundColor:
                      WidgetStateColor.resolveWith((states) => widget.isLoading
                          ? widget.buttonColor!.withOpacity(0.3)
                          : widget.isEnabled == false
                              ? widget.buttonColor!.withOpacity(0.1)
                              : widget.buttonColor!)),
          child: Center(
            child: widget.isLoading
                ? SizedBox(
                    height: 10,
                    width: 10,
                    child: CircularProgressIndicator.adaptive(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(
                          InvoysesTheme.theme.colorScheme.surface),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.hasLeading ? widget.leading! : const SizedBox(),
                      widget.hasLeading
                          ? const SizedBox(
                              width: 10,
                            )
                          : const SizedBox(),
                      Text(
                        widget.buttonText,
                        style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Figtree',
                            color: widget.textColor,
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
          )),
    );
  }
}

class BottomAlignedButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onPressed;
  final Color? textColor;
  final bool isLoading;
  final bool hasLeading;
  final Widget? leading;
  final ButtonStyle? style;
  final bool? enabled;

  const BottomAlignedButton({
    super.key,
    required this.buttonText,
    this.onPressed,
    this.textColor,
    this.isLoading = false,
    this.hasLeading = false,
    this.enabled,
    this.leading,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        decoration: BoxDecoration(
          color: InvoysesTheme.theme.colorScheme.background,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          child: AppAuthButton(
            buttonText: buttonText,
            enabled: enabled ?? true,
            onPressed: onPressed,
            textColor: textColor,
            isLoading: isLoading,
            hasLeading: hasLeading,
            leading: leading,
            style: style,
          ),
        ),
      ),
    );
  }
}
