import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool outlined;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? const SizedBox(
            width: 20,
            height: 20,
            child:
                CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
          )
        : Text(label);

    if (outlined) {
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton(onPressed: onPressed, child: child),
      );
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: onPressed, child: child),
    );
  }
}
