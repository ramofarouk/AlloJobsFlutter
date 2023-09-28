import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allojobstogo/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton(
      {super.key,
      required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.all(kPaddingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? hint;
  final TextInputType? type;
  final int maxLength;
  const CustomInput(
      {Key? key,
      this.controller,
      this.hint,
      this.type,
      required this.maxLength})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: TextFormField(
          keyboardType: type,
          inputFormatters: [
            LengthLimitingTextInputFormatter(maxLength),
          ],
          style: const TextStyle(
            color: Colors.black,
            fontFamily: currentFontFamily,
            fontSize: 15,
          ),
          decoration: InputDecoration(
              hintText: hint!, border: const OutlineInputBorder()),
          controller: controller,
        ));
  }
}
