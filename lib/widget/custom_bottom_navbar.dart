import 'package:flutter/material.dart';
import 'package:my_podcast/widget/app_theme.dart';
import 'package:my_podcast/widget/theme_manager.dart';
import 'package:provider/provider.dart';

class MyNavBar extends StatefulWidget {
  const MyNavBar({
    @required this.icons,
    @required this.onPressed,
    @required this.activeIndex,
  }) : assert(icons != null);

  final List<IconData> icons;
  final Function(int) onPressed;
  final int activeIndex;

  @override
  _MyNavBarState createState() => _MyNavBarState();
}

class _MyNavBarState extends State<MyNavBar>
    with SingleTickerProviderStateMixin {
  double beaconRadius = 0;
  double maxBeaconRadius = 30;

  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );
  }

  // update widget means rebuild MyNavBar, which involves repainting CustomPaint
  @override
  void didUpdateWidget(MyNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.activeIndex != oldWidget.activeIndex) {
      _startAnimation();
    }
  }

  void _startAnimation() {
    _controller.reset();
    final _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    Tween<double>(begin: 0, end: 1).animate(_curve)
      ..addListener(() {
        setState(() {
          beaconRadius = maxBeaconRadius * _curve.value;
          if (beaconRadius == maxBeaconRadius) {
            beaconRadius = 0;
          }
        });
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(builder: (context, themeManager, _) {
      return Theme(
        data: themeManager.themeData,
        child: Container(
          height: 90,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var i = 0; i < widget.icons.length; i++)
                CustomPaint(
                  foregroundPainter: i == widget.activeIndex
                      ? BeaconPainter(
                          beaconRadius: beaconRadius,
                          maxBeaconRadius: maxBeaconRadius,
                          themeData: themeManager.themeData)
                      : null,
                  child: GestureDetector(
                    child: Icon(
                      widget.icons[i],
                      color: i == widget.activeIndex
                          ? Theme.of(context).accentColor
                          : Colors.black45,
                    ),
                    // onTap triggers the change of activeIndex, which triggers didUpdateWidget to rebuild MyNavBar
                    onTap: () => widget.onPressed(i),
                  ),
                )
            ],
          ),
        ),
      );
    });
  }
}

class BeaconPainter extends CustomPainter {
  final double beaconRadius;
  final double maxBeaconRadius;
  // pass theme data to child widget
  final ThemeData themeData;

  BeaconPainter({
    this.beaconRadius,
    this.maxBeaconRadius,
    this.themeData,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (beaconRadius == maxBeaconRadius) {
      return null;
    }
    double strokeWidth = beaconRadius < maxBeaconRadius / 2
        ? beaconRadius
        : maxBeaconRadius - beaconRadius;

    final paint = Paint()
      ..color = themeData.accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(
      Offset(customIconSize / 2, customIconSize / 2),
      beaconRadius,
      paint,
    );
  }

  @override
  bool shouldRepaint(BeaconPainter oldDelegate) => true;
}
