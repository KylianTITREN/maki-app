import 'package:flutter/material.dart';

class PisaTower extends StatefulWidget {
  PisaTower({
    this.hasRoundedBorderLeft: false,
    this.hasRoundedBorderRight: false,
    this.radius: 10.0,
    this.tilt: 0.0,
    this.maxSize: const Size(100, 100),
    this.foregroundWidth: 0.0,
    this.color,
    this.backgroundColor,
  });

  final bool hasRoundedBorderLeft;
  final bool hasRoundedBorderRight;
  final double radius;
  final double tilt;
  final Size maxSize;
  final double foregroundWidth;
  final Color color;
  final Color backgroundColor;

  @override
  State<StatefulWidget> createState() => _PisaTowerState(
        this.hasRoundedBorderLeft,
        this.hasRoundedBorderRight,
        this.radius,
        this.tilt,
        this.maxSize,
        this.foregroundWidth,
        this.color,
        this.backgroundColor,
      );
}

class _PisaTowerState extends State<PisaTower> {
  _PisaTowerState(
    this._isFirst,
    this._isLast,
    this._radius,
    this._tilt,
    this._maxSize,
    this._width,
    this._color,
    this._backgroundColor,
  );

  bool _isFirst;
  bool _isLast;
  double _radius;
  double _tilt;
  Size _maxSize;
  double _width;
  Color _color;
  Color _backgroundColor;

  @override
  void didUpdateWidget(PisaTower oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.hasRoundedBorderLeft != widget.hasRoundedBorderLeft) {
      _isFirst = widget.hasRoundedBorderLeft;
    }

    if (oldWidget.hasRoundedBorderRight != widget.hasRoundedBorderRight) {
      _isLast = widget.hasRoundedBorderRight;
    }

    if (oldWidget.radius != widget.radius) {
      _radius = widget.radius;
    }

    if (oldWidget.tilt != widget.tilt) {
      _tilt = widget.tilt;
    }

    if (oldWidget.maxSize != widget.maxSize) {
      _maxSize = widget.maxSize;
    }

    if (oldWidget.foregroundWidth != widget.foregroundWidth) {
      _width = widget.foregroundWidth;
    }

    if (oldWidget.color != widget.color) {
      _color = widget.color;
    }

    if (oldWidget.backgroundColor != widget.backgroundColor) {
      _backgroundColor = widget.backgroundColor;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: _maxSize,
      willChange: true,
      painter:
          PisaTowerPainter(_isFirst, _isLast, _radius, _tilt, _width, _color, _backgroundColor),
    );
  }
}

class PisaTowerPainter extends CustomPainter {
  PisaTowerPainter(
    this.isFirst,
    this.isLast,
    this.radius,
    this.offset,
    this.foregroundWidth,
    this.color,
    this.backgroundColor,
  );

  bool isFirst;
  bool isLast;
  double radius;
  double offset;
  double foregroundWidth;
  Color color;
  Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint();
    Path path;

    // Background

    paint.color = backgroundColor;

    if (isFirst) {
      path = new Path()
        ..moveTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width - offset, size.height)
        ..lineTo(radius, size.height)
        ..quadraticBezierTo(0, size.height, 0, size.height - radius);
    } else if (isLast) {
      path = new Path()
        ..moveTo(offset, 0)
        ..lineTo(size.width - radius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, radius)
        ..lineTo(size.width, size.height - radius)
        ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
        ..lineTo(0, size.height);
    } else {
      path = new Path()
        ..addPolygon(<Offset>[
          Offset(offset, 0),
          Offset(size.width, 0),
          Offset(size.width - offset, size.height),
          Offset(0, size.height),
        ], true);
    }

    canvas.drawPath(path, paint);

    // Foreground

    paint.color = color;

    if (isFirst && foregroundWidth > 0) {
      path = new Path()
        ..moveTo(0, radius)
        ..quadraticBezierTo(0, 0, radius, 0)
        ..lineTo(foregroundWidth, 0)
        ..lineTo(foregroundWidth - offset, size.height)
        ..lineTo(radius, size.height)
        ..quadraticBezierTo(0, size.height, 0, size.height - radius);
    } else if (isLast && foregroundWidth > 0) {
      path = new Path()
        ..moveTo(offset, 0)
        ..lineTo(size.width - radius, 0)
        ..quadraticBezierTo(size.width, 0, size.width, radius)
        ..lineTo(size.width, size.height - radius)
        ..quadraticBezierTo(size.width, size.height, size.width - radius, size.height)
        ..lineTo(0, size.height);
    } else {
      path = new Path()
        ..addPolygon(<Offset>[
          Offset(offset, 0),
          Offset(offset + foregroundWidth, 0),
          Offset(foregroundWidth, size.height),
          Offset(0, size.height),
        ], true);
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(PisaTowerPainter oldDelegate) {
    return true;
//    return oldDelegate.offset != this.offset ||
//        oldDelegate.maxSize != this.maxSize ||
//        oldDelegate.color != this.color ||
//        oldDelegate.backgroundColor != this.backgroundColor ||
//        oldDelegate.currentWidth != this.currentWidth;
  }
}
