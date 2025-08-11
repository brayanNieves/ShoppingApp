import 'package:flutter/material.dart';

class BuildCustomButton extends StatelessWidget {
  final Color? color;
  final VoidCallback? onPressed;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double padding;
  final double borderRadius;
  final Color borderColor;
  final double? width;
  final double height;
  final String text;
  final bool enable;
  final Color? textColor;
  final double? textSize;
  final double? elevation;
  final VoidCallback? onLongPress;
  final VoidCallback? onDisableTap;

  const BuildCustomButton({
    super.key,
    this.color,
    this.height = 56.0,
    this.onPressed,
    this.fontWeight = FontWeight.bold,
    this.width,
    this.borderColor = Colors.transparent,
    this.fontSize,
    this.padding = 0.0,
    this.borderRadius = 100.0,
    this.text = '',
    this.enable = true,
    this.textColor,
    this.textSize,
    this.elevation,
    this.onLongPress,
    this.onDisableTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          border: Border.all(
            color: borderColor,
            strokeAlign: BorderSide.strokeAlignOutside,
            style: BorderStyle.solid,
          ),
        ),
        child: MaterialButton(
          key: key,
          onLongPress: onLongPress,
          elevation: elevation,
          onPressed: !enable ? onDisableTap ?? () {} : onPressed,
          height: height,
          color: color ?? Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minWidth: width,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: fontWeight,
              fontSize: fontSize,
              color: textColor ?? Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleIconButton extends StatelessWidget {
  final IconData icon;
  final double size;
  final VoidCallback? onTap;

  const CircleIconButton({required this.icon, this.onTap, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      radius: size / 2,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.black87, size: size * .55),
      ),
    );
  }
}
