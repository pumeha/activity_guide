import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final bool bold;
  final TextAlign? textAlign;
  final bool? softWrap;
  final bool currency;
  const AppText({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize,
    this.bold = false,
    this.textAlign,this.softWrap,this.currency = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(maxLines: 2,
      text,
      textAlign: textAlign,
      softWrap: softWrap,
      style: currency ? TextStyle( fontFamily: 'Roboto',
        fontSize: fontSize,fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
        color: color,) : GoogleFonts.outfit(//textStyle: Theme.of(context).textTheme.bodySmall,
        fontSize: fontSize,
        fontWeight: bold ? FontWeight.w700 : FontWeight.normal,
        color: color,
      ),
    );
  }
}
