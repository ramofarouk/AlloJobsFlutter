import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:allojobstogo/utils/constants.dart';

class CustomButton extends StatelessWidget {
  final Color color;
  final Color textColor;
  final String text;
  final VoidCallback onPressed;

  const CustomButton(
      {required this.color,
      required this.textColor,
      required this.text,
      required this.onPressed})
      : assert(color != null),
        assert(textColor != null),
        assert(text != null),
        assert(onPressed != null);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(
        minWidth: double.infinity,
      ),
      child: FlatButton(
        color: color,
        padding: EdgeInsets.all(kPaddingM),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4.0),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .subtitle1!
              .copyWith(color: textColor, fontWeight: FontWeight.bold),
        ),
        onPressed: onPressed,
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
          style: TextStyle(
            color: Colors.black,
            fontFamily: currentFontFamily,
            fontSize: 15,
          ),
          decoration:
              InputDecoration(hintText: hint!, border: OutlineInputBorder()),
          controller: controller,
        ));
  }
}
