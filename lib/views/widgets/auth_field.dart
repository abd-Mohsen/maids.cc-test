import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  const AuthField({
    super.key,
    required this.controller,
    this.keyboardType,
    required this.label,
    this.obscure,
    required this.prefixIcon,
    this.suffixIcon,
    required this.validator,
    required this.onChanged,
  });

  final TextEditingController controller;
  final TextInputType? keyboardType;
  final String label;
  final bool? obscure;
  final Widget prefixIcon;
  final Widget? suffixIcon;
  final String? Function(String?) validator;
  final void Function(String?) onChanged;

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        obscureText: obscure ?? false,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          //hintText: "password".tr,
          label: Text(label),
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
        ),
        style: tt.titleMedium!.copyWith(color: cs.onBackground),
        validator: validator,
        onChanged: onChanged,
      ),
    );
  }
}

String? validateInput(String val, int min, int max, String type,
    {String pass = "", String rePass = "", bool canBeEmpty = false}) {
  if (val.trim().isEmpty && !canBeEmpty) return "cannot be empty";

  if (val.length < min) return "must be greater than $min characters";

  if (val.length > max) return "must be less than $max characters";

  if (pass != rePass) return "passwords don't match";

  return null;
}
