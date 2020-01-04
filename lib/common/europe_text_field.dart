import 'package:flutter/material.dart';

class EuropeTextFormField extends StatelessWidget {
  const EuropeTextFormField({
    Key key,
    this.hint,
    this.icon,
    this.onTap,
    this.value,
    this.controller,
    this.onFieldSubmitted,
    this.onChanged,
    this.maxLength,
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
    this.obscureText = false,
    this.additionalValidator,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final VoidCallback onTap;
  final String value;
  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final ValueChanged<String> onChanged;
  final int maxLength;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final bool obscureText;
  final FormFieldValidator<String> additionalValidator;

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderSide: BorderSide(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[200]
            : Colors.grey[700],
      ),
      borderRadius: BorderRadius.circular(12),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 10.0,
      ),
      child: TextFormField(
        controller: controller,
        onFieldSubmitted: onFieldSubmitted,
        onChanged: onChanged,
        focusNode: focusNode,
        keyboardType: keyboardType,
        maxLength: maxLength,
        validator: (value) {
          if (value.length == 0) {
            return 'Please fill this field.';
          }
          if (value.length != maxLength) {
            return 'This field should have $maxLength characters.';
          }
          if (additionalValidator != null) return additionalValidator(value);
          return null;
        },
        textInputAction: TextInputAction.next,
        textCapitalization: textCapitalization,
        keyboardAppearance: Theme.of(context).brightness,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          enabledBorder: border,
          border: border,
          focusedBorder: border.copyWith(
            borderSide: BorderSide(
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey[300]
                  : Colors.grey[600],
            ),
          ),
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          suffixIcon: IconButton(
            onPressed: onTap,
            icon: Icon(icon),
          ),
        ),
      ),
    );
  }
}
