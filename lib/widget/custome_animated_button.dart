import 'package:flutter/material.dart';

/// Animated Scale Button
class CustomeAnimatedButton extends StatefulWidget {
  final String title;
  final dynamic onTap;
  final bool isShowShadow;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? titleColor;
  final IconData? leadingIcon;
  final double? leadingIconSize;
  final Color? leadingIconColor;
  final double? width;
  final double? hegith;

  const CustomeAnimatedButton({
    required this.title,
    required this.onTap,
    required this.isShowShadow,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.titleColor,
    this.leadingIcon,
    this.leadingIconSize,
    this.leadingIconColor,
    this.width,
    this.hegith,
  });

  @override
  _CustomeAnimatedButtonState createState() => _CustomeAnimatedButtonState();
}

class _CustomeAnimatedButtonState extends State<CustomeAnimatedButton> with SingleTickerProviderStateMixin {
  double? _scale;
  late AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTap() {
    _controller.forward();
    Future.delayed(const Duration(milliseconds: 150)).whenComplete(() {
      _controller.reverse();
    });
    widget.onTap();

    print('ontap 123');
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;

    return GestureDetector(
      onTap: _onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      child: Transform.scale(
        scale: _scale!,
        child: _animatedButtonUI,
      ),
    );
  }

  Widget get _animatedButtonUI => Container(
        alignment: Alignment.center,
        width: widget.width ?? MediaQuery.of(context).size.width / 3,
        height: widget.hegith ?? 30,
        padding: widget.padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          boxShadow: widget.isShowShadow ? [BoxShadow(blurRadius: 1, spreadRadius: 1, offset: const Offset(0, 1), color: Colors.grey.withOpacity(0.4))] : [],
          borderRadius: BorderRadius.circular(widget.radius ?? 99),
          border: Border.all(color: widget.borderColor ?? Colors.white),
          color: widget.backgroundColor ?? Colors.green,
        ),
        child: widget.leadingIcon != null
            ? RichText(
                text: TextSpan(
                  children: [
                    WidgetSpan(child: Icon(widget.leadingIcon, color: widget.leadingIconColor ?? Colors.white, size: widget.leadingIconSize ?? 18)),
                    const WidgetSpan(child: SizedBox(width: 3)),
                    TextSpan(text: widget.title, style: TextStyle(color: widget.titleColor ?? Colors.white)),
                  ],
                ),
              )
            : Text(
                widget.title,
                style: TextStyle(
                  color: widget.titleColor ?? Colors.white,
                ),
              ),
      );
}
