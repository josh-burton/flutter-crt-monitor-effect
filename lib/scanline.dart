import 'dart:async';
import 'dart:ui' as ui;

import 'package:after_layout/after_layout.dart';
import 'package:crt_monitor_effect/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:keyframes_tween/keyframes_tween.dart';

class Scanline extends StatefulWidget {
  final Widget child;
  final bool enabled;

  const Scanline({
    Key? key,
    required this.child,
    required this.enabled,
  }) : super(key: key);

  @override
  State<Scanline> createState() => _ScanlineState();
}

class _ScanlineState extends State<Scanline> with AfterLayoutMixin {
  final Completer<ui.Image> _rawImage = Completer();
  final GlobalKey _pixelKey = GlobalKey();

  // captures the single pixel as a ui.image for use in an ImageShader
  Future<void> _renderImage() async {
    try {
      final pixelRenderObject = _pixelKey.currentContext!.findRenderObject();
      RenderRepaintBoundary boundary = pixelRenderObject as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 1);
      _rawImage.complete(image);
    } catch (e) {
      _scheduleRender();
    }
  }

  Future<void> _scheduleRender() async {
    await Future.delayed(const Duration(milliseconds: 1));
    scheduleMicrotask(() {
      _renderImage();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return Stack(
      children: [
        RepaintBoundary(
          key: _pixelKey,
          child: const _Pixel(
            width: 2,
            height: 3,
          ),
        ),
        // renders a repeated 'pixel' over the entire content
        FutureBuilder(
          future: _rawImage.future,
          builder: (context, AsyncSnapshot<ui.Image> image) {
            return (image.hasData)
                ? ShaderMask(
                    shaderCallback: (bounds) => ImageShader(
                      image.data!,
                      TileMode.repeated,
                      TileMode.repeated,
                      Matrix4.identity().storage,
                    ),
                    blendMode: BlendMode.hardLight,
                    child: widget.child,
                  )
                : widget.child;
          },
        ),
        // renders a transparent flicker over the entire content
        Flicker(
          child: Container(
            color: const Color.fromRGBO(18, 16, 16, 0.08),
          ),
        ),
      ],
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _renderImage();
  }
}

/// A widget that simulates a CRT monitor pixel
class _Pixel extends StatelessWidget {
  final double width;
  final double height;

  const _Pixel({Key? key, this.width = 2, this.height = 2}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.only(right: width / 2, bottom: width / 4),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: 2,
            height: 1,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromRGBO(255, 0, 0, 0.06),
                  Color.fromRGBO(0, 255, 0, 0.02),
                  Color.fromRGBO(0, 0, 255, 0.06),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: .5,
              child: Container(
                color: const Color.fromRGBO(0, 0, 0, .5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A widget that flickers its content on and off
class Flicker extends StatefulWidget {
  final Widget child;

  const Flicker({Key? key, required this.child}) : super(key: key);

  @override
  _FlickerState createState() => _FlickerState();
}

class _FlickerState extends State<Flicker> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 100));
    _animationController.repeat(reverse: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      child: widget.child,
      builder: (context, widget) {
        final int tween = IntTween(begin: 0, end: 1).evaluate(_animationController);
        return Opacity(
          opacity: tween.toDouble(),
          child: widget!,
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

/// A widget that renders Text with animated blue/red shadows that simulates chromatic aberration of an old` CRT monitor
class ChromaticText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const ChromaticText({
    Key? key,
    required this.text,
    required this.style,
  }) : super(key: key);

  @override
  State<ChromaticText> createState() => _ChromaticTextState();
}

class _ChromaticTextState extends State<ChromaticText> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _animationController.repeat(reverse: false);
    super.initState();
  }

  final tween = KeyframesTween([
    KeyframeProperty<double>([
      (-0.4389924193300864).keyframe(0 / 100, Curves.ease),
      (-2.7928974010788217).keyframe(5 / 100, Curves.ease),
      (-0.02956275843481219).keyframe(10 / 100, Curves.ease),
      (-0.40218538552878136).keyframe(15 / 100, Curves.ease),
      (-3.4794037899852017).keyframe(20 / 100, Curves.ease),
      (-1.6125630401149584).keyframe(25 / 100, Curves.ease),
      (-0.7015590085143956).keyframe(30 / 100, Curves.ease),
      (-3.896914047650351).keyframe(35 / 100, Curves.ease),
      (-3.870905614848819).keyframe(40 / 100, Curves.ease),
      (-2.231056963361899).keyframe(45 / 100, Curves.ease),
      (-0.08084290417898504).keyframe(50 / 100, Curves.ease),
      (-2.3758461067427543).keyframe(55 / 100, Curves.ease),
      (-2.202193051050636).keyframe(60 / 100, Curves.ease),
      (-2.8638780614874975).keyframe(65 / 100, Curves.ease),
      (-0.48874025155497314).keyframe(70 / 100, Curves.ease),
      (-1.8948491305757957).keyframe(75 / 100, Curves.ease),
      (-0.0833037308038857).keyframe(80 / 100, Curves.ease),
      (-0.09769827255241735).keyframe(85 / 100, Curves.ease),
      (-3.443339761481782).keyframe(90 / 100, Curves.ease),
      (-2.1841838852799786).keyframe(95 / 100, Curves.ease),
      (-2.6208764473832513).keyframe(100 / 100, Curves.ease),
    ], name: 'red'),
    KeyframeProperty<double>([
      0.4389924193300864.keyframe(0 / 100, Curves.ease),
      2.7928974010788217.keyframe(5 / 100, Curves.ease),
      0.02956275843481219.keyframe(10 / 100, Curves.ease),
      0.40218538552878136.keyframe(15 / 100, Curves.ease),
      3.4794037899852017.keyframe(20 / 100, Curves.ease),
      1.6125630401149584.keyframe(25 / 100, Curves.ease),
      0.7015590085143956.keyframe(30 / 100, Curves.ease),
      3.896914047650351.keyframe(35 / 100, Curves.ease),
      3.870905614848819.keyframe(40 / 100, Curves.ease),
      2.231056963361899.keyframe(45 / 100, Curves.ease),
      0.08084290417898504.keyframe(50 / 100, Curves.ease),
      2.3758461067427543.keyframe(55 / 100, Curves.ease),
      2.202193051050636.keyframe(60 / 100, Curves.ease),
      2.8638780614874975.keyframe(65 / 100, Curves.ease),
      0.48874025155497314.keyframe(70 / 100, Curves.ease),
      1.8948491305757957.keyframe(75 / 100, Curves.ease),
      0.0833037308038857.keyframe(80 / 100, Curves.ease),
      0.09769827255241735.keyframe(85 / 100, Curves.ease),
      3.443339761481782.keyframe(90 / 100, Curves.ease),
      2.1841838852799786.keyframe(95 / 100, Curves.ease),
      2.6208764473832513.keyframe(100 / 100, Curves.ease),
    ], name: 'blue'),
    KeyframeProperty<double>([
      5.0.keyframe(0 / 100, Curves.ease),
      8.0.keyframe(25 / 100, Curves.ease),
      0.0.keyframe(50 / 100, Curves.ease),
      5.0.keyframe(75 / 100, Curves.ease),
      10.0.keyframe(100 / 100, Curves.ease),
    ], name: 'green'),
    KeyframeProperty<double>([
      2.0.keyframe(0 / 100, Curves.ease),
      6.0.keyframe(50 / 100, Curves.ease),
      1.0.keyframe(100 / 100, Curves.ease),
    ], name: 'green-offset'),
  ]);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ValueListenableBuilder<KeyframeValue>(
      valueListenable: tween.animate(_animationController),
      builder: (context, values, _) {
        double redOffset = values<double>('red');
        double blueOffset = values<double>('blue');
        return Text(
          widget.text,
          style: widget.style.copyWith(
            shadows: [
              Shadow(
                color: const Color.fromRGBO(0, 30, 255, .5),
                blurRadius: 1,
                offset: Offset(blueOffset, 0),
              ),
              Shadow(
                color: const Color.fromRGBO(255, 0, 80, .3),
                blurRadius: 1,
                offset: Offset(redOffset, 0),
              ),
              Shadow(
                blurRadius: values<double>('green'),
                color: secondaryColor.withOpacity(.1),
                offset: Offset(values<double>('green-offset'), 0),
              ),
              const Shadow(
                blurRadius: 3,
                offset: Offset(0, 0),
              ),
            ],
          ),
        );
      },
    );
  }
}
