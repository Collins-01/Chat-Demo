import 'package:flutter/material.dart';
import 'package:harmony_chat_demo/utils/utils.dart';

class AppText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final bool multiText;
  final TextAlign? textAlign;
  final TextOverflow overflow;
  final Color? color;
  final bool centered;
  final int? maxLines;
  final double? fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? lineHeight;

  /// biggest text
  ///
  /// fontSize `32`
  /// fontWeight `700`
  AppText.heading1(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.centered = false,
    this.color,
    this.maxLines,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.lineHeight,
    this.wordSpacing,
  })  : style = headingStyle1Bold.copyWith(color: color),
        super(key: key);

  /// h2 text
  ///
  // fontSize `29`
  // fontWeight `700`
  AppText.heading2(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
  })  : style = headingStyle2Bold.copyWith(color: color),
        super(key: key);

  /// h3 text
  ///
  /// fontSize `26`
  /// fontWeight `700`
  AppText.heading3(this.text,
      {Key? key,
      this.multiText = true,
      this.overflow = TextOverflow.ellipsis,
      this.color,
      this.maxLines,
      this.centered = false,
      this.textAlign,
      this.fontSize,
      this.wordSpacing,
      this.lineHeight,
      this.letterSpacing})
      : style = headingStyle3Bold.copyWith(color: color),
        super(key: key);

  /// h4text
  //
  // / fontSize `22`
  // / fontWeight `700`
  AppText.heading4(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.lineHeight,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
  })  : style = headingStyle4Bold.copyWith(
          color: color,
          fontSize: fontSize,
        ),
        super(key: key);

  /// h5 text
  ///
  /// fontSize `16`
  /// fontWeight `500`
  AppText.heading5(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
  })  : style = headingStyle5Bold.copyWith(color: color),
        super(key: key);

  /// h6 text
  ///
  /// fontSize `14`
  /// fontWeight `500`
  AppText.heading6(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
  })  : style = headingStyle6Bold.copyWith(color: color),
        super(key: key);

  /// normal body text
  ///
  /// fontSize `14`
  /// fontWeight `700`
  AppText.body(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    double? height,
    this.centered = false,
    this.lineHeight,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
  }) : style = bodySmall.copyWith(
          color: color,
          height: height,
          fontSize: fontSize,
        );

  AppText.bodyLarge(this.text,
      {Key? key,
      this.multiText = true,
      this.overflow = TextOverflow.ellipsis,
      this.color,
      this.maxLines,
      this.centered = false,
      this.textAlign,
      this.wordSpacing,
      this.lineHeight,
      this.fontSize,
      this.letterSpacing})
      : style = bodyLarge.copyWith(color: color),
        super(key: key);

  /// smallest text
  ///
  /// fontSize `13`
  /// fontWeight `500`
  AppText.small(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.lineHeight,
    this.wordSpacing,
  })  : style = bodySmall.copyWith(color: color),
        super(key: key);

  /// semibold text
  ///
  /// fontSize `11`
  /// fontWeight `400`
  AppText.caption(
    this.text, {
    Key? key,
    this.multiText = true,
    this.overflow = TextOverflow.ellipsis,
    this.color,
    this.maxLines,
    this.centered = false,
    this.textAlign,
    this.fontSize,
    this.letterSpacing,
    this.wordSpacing,
    this.lineHeight,
  })  : style = caption.copyWith(
          color: color,
          fontSize: fontSize,
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: multiText || maxLines != null ? maxLines ?? 9999999999 : 1,
      overflow: overflow,
      textAlign: centered ? TextAlign.center : textAlign ?? TextAlign.left,
      style: style.copyWith(
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        color: color ?? AppColors.textColor,
        height: lineHeight,
        fontSize: fontSize,
      ),
    );
  }
}
