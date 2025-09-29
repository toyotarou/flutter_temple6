import 'package:flutter/material.dart';

class ExpandableBox extends StatefulWidget {
  const ExpandableBox({
    super.key,
    this.collapsedSize = const Size(48, 48),
    this.expandedSize = const Size(200, 200),
    this.duration = const Duration(milliseconds: 800),
    this.curve = Curves.easeInOut,
    this.widthInterval = const Interval(0.00, 0.55, curve: Curves.easeInOut),
    this.heightInterval = const Interval(0.20, 0.90, curve: Curves.easeInOut),
    this.decoration,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.collapsedChild = const SizedBox.shrink(),
    this.expandedChild,
    this.toggleIcon = const Icon(Icons.expand, size: 18, color: Colors.white),
    this.toggleButtonPadding = const EdgeInsets.all(6),
    this.toggleButtonBgColor = const Color(0x66000000),
    required this.alignment,
    this.keepFullWidth = false,
  });

  final Size collapsedSize;
  final Size expandedSize;

  final Duration duration;
  final Curve curve;
  final Interval widthInterval;
  final Interval heightInterval;

  final BoxDecoration? decoration;
  final BorderRadius borderRadius;

  final Widget collapsedChild;
  final Widget? expandedChild;

  final Widget toggleIcon;
  final EdgeInsets toggleButtonPadding;
  final Color toggleButtonBgColor;

  final Alignment alignment;
  final bool keepFullWidth;

  @override
  State<ExpandableBox> createState() => _ExpandableState();
}

class _ExpandableState extends State<ExpandableBox> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final CurvedAnimation _curved;

  late Animation<double> _widthAnim;
  late Animation<double> _heightAnim;

  late Animation<double> _contentOpacity;
  late Animation<double> _contentScale;

  bool _expanded = false;

  ///
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _curved = CurvedAnimation(parent: _controller, curve: widget.curve);

    _widthAnim = Tween<double>(
      begin: widget.collapsedSize.width,
      end: widget.expandedSize.width,
    ).animate(CurvedAnimation(parent: _curved, curve: widget.widthInterval));

    _heightAnim = Tween<double>(
      begin: widget.collapsedSize.height,
      end: widget.expandedSize.height,
    ).animate(CurvedAnimation(parent: _curved, curve: widget.heightInterval));

    _contentOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _curved,
        curve: const Interval(0.90, 1.00, curve: Curves.easeOut),
      ),
    );

    _contentScale = Tween<double>(begin: 0.96, end: 1.0).animate(
      CurvedAnimation(
        parent: _curved,
        curve: const Interval(0.90, 1.00, curve: Curves.easeOutBack),
      ),
    );
  }

  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  ///
  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  ///
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double parentWidth = constraints.maxWidth;

        return Align(
          alignment: widget.alignment,

          child: AnimatedBuilder(
            animation: _controller,
            builder: (BuildContext context, _) {
              final bool full = widget.keepFullWidth;

              final double outerWidth = full ? parentWidth : _widthAnim.value;

              final double h = _heightAnim.value;

              final double toggleInset = (full ? 10.0 : 0.0) + 6.0;

              return SizedBox(
                width: outerWidth,
                height: h,

                child: ClipRRect(
                  borderRadius: widget.borderRadius,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: widget.decoration ?? const BoxDecoration(color: Colors.blue),
                    child: Stack(
                      children: <Widget>[
                        if (!_expanded) Positioned.fill(child: Center(child: widget.collapsedChild)),
                        if (_expanded)
                          Positioned.fill(
                            child: IgnorePointer(
                              ignoring: _contentOpacity.value < 0.99,
                              child: FadeTransition(
                                opacity: _contentOpacity,
                                child: ScaleTransition(
                                  scale: _contentScale,
                                  child:
                                      widget.expandedChild ??
                                      const Center(
                                        child: Text(
                                          'Expanded',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                ),
                              ),
                            ),
                          ),

                        Positioned(
                          top: 6,

                          right: toggleInset,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _toggle,
                              customBorder: const CircleBorder(),
                              child: Container(
                                padding: widget.toggleButtonPadding,
                                decoration: BoxDecoration(color: widget.toggleButtonBgColor, shape: BoxShape.circle),
                                child: widget.toggleIcon,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          top: 6,

                          right: 60,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              customBorder: const CircleBorder(),
                              child: Container(
                                padding: widget.toggleButtonPadding,
                                decoration: BoxDecoration(color: widget.toggleButtonBgColor, shape: BoxShape.circle),
                                child: const Icon(Icons.photo_outlined, size: 18, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
