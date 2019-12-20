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
    this.focusNode,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  final String hint;
  final IconData icon;
  final VoidCallback onTap;
  final String value;
  final TextEditingController controller;
  final ValueChanged<String> onFieldSubmitted;
  final FocusNode focusNode;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

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
        focusNode: focusNode,
        keyboardType: keyboardType,
        validator: (value){
          if (value.length == 0){
            return 'Please fill this field';
          }
          return null;
        },
        textInputAction: TextInputAction.next,
        textCapitalization: textCapitalization,
        keyboardAppearance: Theme.of(context).brightness,
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
