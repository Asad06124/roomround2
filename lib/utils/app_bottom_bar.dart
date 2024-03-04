import 'package:flutter/material.dart';

class AppBottomBar extends StatefulWidget {
  const AppBottomBar({
    Key? key,
    required this.activeIndex,
    this.onTap,
    this.tabCurve = Curves.linearToEaseOut,
    this.iconCurve = Curves.bounceOut,
    this.tabDurationMillSec = 1000,
    this.iconDurationMillSec = 500,
    required this.activeIcons,
    required this.inactiveIcons,
    required this.height,
    required this.circleWidth,
    required this.color,
    this.circleColor,
    this.activeLabelStyle,
    this.inactiveLabelStyle,
    this.labels,
    this.padding = EdgeInsets.zero,
    this.cornerRadius = BorderRadius.zero,
    this.shadowColor = Colors.white,
    this.circleShadowColor,
    this.elevation = 0,
    this.gradient,
    this.circleGradient,
  })  : assert(circleWidth <= height, "circleWidth <= height"),
        assert(activeIcons.length == inactiveIcons.length,
            "activeIcons.length and inactiveIcons.length must be equal!"),
        assert(activeIcons.length > activeIndex,
            "activeIcons.length > activeIndex"),
        super(key: key);

  final double height;

  final double circleWidth;

  final Color color;

  final Color? circleColor;

  final List<Widget> activeIcons;

  final List<Widget> inactiveIcons;

  final EdgeInsets padding;

  final BorderRadius cornerRadius;

  final Color shadowColor;

  final Color? circleShadowColor;

  final double elevation;

  final Gradient? gradient;

  final Gradient? circleGradient;

  final int activeIndex;

  final Curve tabCurve;

  final Curve iconCurve;

  final int tabDurationMillSec;

  final int iconDurationMillSec;

  final Function(int index)? onTap;

  final List<String>? labels;

  final TextStyle? inactiveLabelStyle;

  final TextStyle? activeLabelStyle;

  @override
  State<StatefulWidget> createState() => _AppBottomBarState();
}

class _AppBottomBarState extends State<AppBottomBar>
    with TickerProviderStateMixin {
  late AnimationController tabAc;

  late AnimationController activeIconAc;

  @override
  void initState() {
    super.initState();
    tabAc = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.tabDurationMillSec))
      ..addListener(() => setState(() {}))
      ..value = getPosition(widget.activeIndex);
    activeIconAc = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.iconDurationMillSec))
      ..addListener(() => setState(() {}))
      ..value = 1;
  }

  @override
  void didUpdateWidget(covariant AppBottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _animation();
  }

  void _animation() {
    final nextPosition = getPosition(widget.activeIndex);
    tabAc.stop();
    tabAc.animateTo(nextPosition, curve: widget.tabCurve);
    activeIconAc.reset();
    activeIconAc.animateTo(1, curve: widget.iconCurve);
  }

  double getPosition(int i) {
    int itemCnt = widget.activeIcons.length;
    return i / itemCnt + (1 / itemCnt) / 2;
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: widget.padding,
      width: double.infinity,
      height: widget.height,
      child: Column(
        children: [
          CustomPaint(
            painter: _CircleBottomPainter(
              iconWidth: widget.circleWidth,
              color: widget.color,
              circleColor: widget.circleColor ?? widget.color,
              xOffsetPercent: tabAc.value,
              boxRadius: widget.cornerRadius,
              shadowColor: widget.shadowColor,
              circleShadowColor: widget.circleShadowColor ?? widget.shadowColor,
              elevation: widget.elevation,
              gradient: widget.gradient,
              circleGradient: widget.circleGradient ?? widget.gradient,
            ),
            child: SizedBox(
              height: widget.height,
              width: double.infinity,
              child: Stack(
                children: [
                  Row(
                    children: widget.inactiveIcons.map((e) {
                      int currentIndex = widget.inactiveIcons.indexOf(e);
                      return Expanded(
                          child: GestureDetector(
                        onTap: () => widget.onTap?.call(currentIndex),
                        child: Container(
                          width: double.infinity,
                          height: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          color: Colors.transparent,
                          alignment: Alignment.center,
                          child: widget.activeIndex == currentIndex ? null : e,
                        ),
                      ));
                    }).toList(),
                  ),
                  Positioned(
                      left: tabAc.value * deviceWidth -
                          widget.circleWidth / 2 -
                          tabAc.value *
                              (widget.padding.left + widget.padding.right),
                      child: Transform.scale(
                        scale: activeIconAc.value,
                        child: Container(
                          width: widget.circleWidth,
                          height: widget.circleWidth,
                          padding: const EdgeInsets.all(10),
                          transform: Matrix4.translationValues(
                              0,
                              -(widget.circleWidth * 0.5) +
                                  _CircleBottomPainter.getMiniRadius(
                                      widget.circleWidth) -
                                  widget.circleWidth *
                                      0.5 *
                                      (1 - activeIconAc.value),
                              0),
                          // color: Colors.amber,
                          child: widget.activeIcons[widget.activeIndex],
                        ),
                      )),
                  if (widget.labels != null) ...{
                    Positioned(
                      width: deviceWidth,
                      bottom: 5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ...List.generate(widget.labels!.length, (index) {
                            return SizedBox(
                              width: deviceWidth / widget.labels!.length,
                              child: Center(
                                child: Text(
                                  widget.labels![index],
                                  style: widget.activeIndex == index
                                      ? widget.activeLabelStyle
                                      : widget.inactiveLabelStyle,
                                ),
                              ),
                            );
                          })
                        ],
                      ),
                    )
                  }
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleBottomPainter extends CustomPainter {
  _CircleBottomPainter({
    required this.iconWidth,
    required this.color,
    required this.circleColor,
    required this.xOffsetPercent,
    required this.boxRadius,
    required this.shadowColor,
    required this.circleShadowColor,
    required this.elevation,
    this.gradient,
    this.circleGradient,
  });

  final Color color;
  final Color circleColor;
  final double iconWidth;
  final double xOffsetPercent;
  final BorderRadius boxRadius;
  final Color shadowColor;
  final Color circleShadowColor;
  final double elevation;
  final Gradient? gradient;
  final Gradient? circleGradient;

  static double getR(double circleWidth) {
    return circleWidth / 2 * 1.3;
  }

  static double getMiniRadius(double circleWidth) {
    return getR(circleWidth) * 0.15;
  }

  static double convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    Paint paint = Paint();
    Paint? circlePaint;
    if (color != circleColor || circleGradient != null) {
      circlePaint = Paint();
      circlePaint.color = circleColor;
    }

    final w = size.width;
    final h = size.height;
    final r = getR(iconWidth);
    final miniRadius = getMiniRadius(iconWidth);
    final x = xOffsetPercent * w;
    final firstX = x - r;
    final secondX = x + r;

    // TopLeft Radius
    path.moveTo(0, 0 + boxRadius.topLeft.y);
    path.quadraticBezierTo(0, 0, boxRadius.topLeft.x, 0);
    path.lineTo(firstX - miniRadius, 0);
    path.quadraticBezierTo(firstX, 0, firstX, miniRadius);

    path.arcToPoint(
      Offset(secondX, miniRadius),
      radius: Radius.circular(r),
      clockwise: false,
    );

    path.quadraticBezierTo(secondX, 0, secondX + miniRadius, 0);

    // TopRight Radius
    path.lineTo(w - boxRadius.topRight.x, 0);
    path.quadraticBezierTo(w, 0, w, boxRadius.topRight.y);

    // BottomRight Radius
    path.lineTo(w, h - boxRadius.bottomRight.y);
    path.quadraticBezierTo(w, h, w - boxRadius.bottomRight.x, h);

    // BottomLeft Radius
    path.lineTo(boxRadius.bottomLeft.x, h);
    path.quadraticBezierTo(0, h, 0, h - boxRadius.bottomLeft.y);

    path.close();

    paint.color = color;

    if (gradient != null) {
      Rect shaderRect =
          Rect.fromCircle(center: Offset(w / 2, h / 2), radius: 180.0);
      paint.shader = gradient!.createShader(shaderRect);
    }

    if (circleGradient != null) {
      Rect shaderRect =
          Rect.fromCircle(center: Offset(x, miniRadius), radius: iconWidth / 2);
      circlePaint?.shader = circleGradient!.createShader(shaderRect);
    }

    canvas.drawPath(
        path,
        Paint()
          ..color = shadowColor
          ..maskFilter = MaskFilter.blur(
              BlurStyle.normal, convertRadiusToSigma(elevation)));

    canvas.drawCircle(
        Offset(x, miniRadius),
        iconWidth / 2,
        Paint()
          ..color = circleShadowColor
          ..maskFilter = MaskFilter.blur(
              BlurStyle.normal, convertRadiusToSigma(elevation)));

    canvas.drawPath(path, paint);

    canvas.drawCircle(
        Offset(x, miniRadius), iconWidth / 2, circlePaint ?? paint);
  }

  @override
  bool shouldRepaint(_CircleBottomPainter oldDelegate) => oldDelegate != this;
}
