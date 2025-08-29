import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.width = 200,
    this.height = 120,
    this.borderRadius = 12.0,
    this.strokeWidth = 4.0,
    this.duration = const Duration(seconds: 4),
    this.colors = const [Colors.red, Colors.blue, Colors.green],
  });

  final Widget child;
  final double width;
  final double height;
  final double borderRadius;
  final double strokeWidth;
  final Duration duration;
  final List<Color> colors;

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _anim = Tween<double>(begin: 0, end: 2 * 3.141592653589793)
        .animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(widget.borderRadius),
            ),
            child: widget.child,
          ),
          AnimatedBuilder(
            animation: _anim,
            builder: (context, _) {
              return CustomPaint(
                painter: _GradientBorderPainter(
                  rotation: _anim.value,
                  strokeWidth: widget.strokeWidth,
                  radius: widget.borderRadius,
                  colors: widget.colors,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _GradientBorderPainter extends CustomPainter {
  _GradientBorderPainter({
    required this.rotation,
    required this.strokeWidth,
    required this.radius,
    required this.colors,
  });

  final double rotation;
  final double strokeWidth;
  final double radius;
  final List<Color> colors;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = strokeWidth / 2;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
          inset, inset, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );

    final gradient = LinearGradient(
      colors: colors,
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      transform: GradientRotation(rotation),
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = gradient.createShader(rrect.outerRect);

    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant _GradientBorderPainter oldDelegate) {
    return oldDelegate.rotation != rotation ||
        oldDelegate.colors != colors ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
