library fading_slider_animation;

import 'dart:async';

import 'package:flutter/material.dart';

class FadingImagesSlider extends StatefulWidget {
  FadingImagesSlider({
    ///You can change anything about dots.
    this.activeIconColor = Colors.black,

    ///You can change anything about dots.
    this.passiveIconColor = Colors.grey,

    ///You can change anything about dots.
    this.icon = Icons.circle,
    this.animationDuration = const Duration(milliseconds: 800),
    this.autoFade = true,
    this.iconSize = 8,

    ///images and texts is required properties and list length must be same.
    required this.images,

    ///images and texts is required properties and list length must be same.
    this.fadeInterval = const Duration(milliseconds: 5000),
    this.textAlignment = Alignment.bottomCenter,
  });

  final List<Widget> images;
  final IconData? icon;
  final double? iconSize;
  final Color? activeIconColor;
  final Color? passiveIconColor;
  final bool autoFade;
  final Duration animationDuration;
  final Duration fadeInterval;
  final Alignment textAlignment;

  @override
  _FadingImagesSliderState createState() => _FadingImagesSliderState();
}

class _FadingImagesSliderState extends State<FadingImagesSlider> {
  int _numberOfImage = 0;
  bool _onTapped = false;
  bool _isContainerVisible = true;

  void checkListsLength() {
    // if (widget.images.length != widget.texts.length) {
    //   throw 'images.length != texts.length';
    // }
  }

  ///avoid memory leak.
  void setStateIfMounted(f) {
    if (mounted) setState(f);
  }

  List<AnimatedOpacity> _animatedWidgetList = [];

  void _addImagesToList() {
    int i = 0;
    for (Widget image in widget.images) {
      _animatedWidgetList.add(AnimatedOpacity(
        opacity: _numberOfImage == i ? 1.0 : 0.0,
        duration: widget.animationDuration,
        child: Visibility(
          visible: _numberOfImage == i ? true : false,
          child: Center(
            child: image,
          ),
        ),
      ));
      i++;
    }
  }

  @override
  void initState() {
    _addImagesToList();
    _addDots();
    _autoFade();
    super.initState();
  }

  List<Widget> _dots = [];

  void _addDots() {
    for (int j = 0; j < widget.images.length; j++) {
      _dots.add(_numberOfImage == j
          ? Container(
        height: 8,
        width: 25,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: widget.activeIconColor,
          borderRadius: const BorderRadius.all(Radius.circular(22.0)),
        ),
      )
          : Container(
        height: 8,
        width: 8,
        margin: const EdgeInsets.all(4.0),
        decoration: BoxDecoration(
          color: widget.passiveIconColor,
          borderRadius: const BorderRadius.all(Radius.circular(22.0)),
        ),
      ));
    }
  }

  void _numberOfImageIncrement() {
    if (_numberOfImage < widget.images.length - 1) {
      _numberOfImage++;
    } else {
      _numberOfImage = 0;
    }
    _dots = [];
    _addDots();
    _animatedWidgetList = [];
    _addImagesToList();
  }

  void _numberOfImageDecrement() {
    if (0 < _numberOfImage) {
      _numberOfImage--;
    } else {
      _numberOfImage = widget.images.length - 1;
    }
    _dots = [];
    _addDots();
    _animatedWidgetList = [];
    _addImagesToList();
  }

  void _autoFade() {
    if (widget.autoFade && _onTapped != true) {
      Timer.periodic(widget.fadeInterval, (timer) {
        if (_onTapped) {
          timer.cancel();
        } else {
          setStateIfMounted(() {
            _numberOfImageIncrement();
          });
        }
        // timer.cancel();
      });
    }
  }

  @override
  void dispose() {
    _autoFade();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double start = 1;
    double end = 1;
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _numberOfImageIncrement();
              setStateIfMounted(() {
                _onTapped = true;
              });
            },
            onScaleStart: (details) {
              start = details.localFocalPoint.dx;
            },
            onScaleUpdate: (details) {
              end = details.localFocalPoint.dx;
            },
            onScaleEnd: (details) {
              setStateIfMounted(() {
                _onTapped = true;
              });
              if (start > end) {
                setStateIfMounted(() {
                  _numberOfImageIncrement();
                });
              } else {
                setStateIfMounted(() {
                  _numberOfImageDecrement();
                });
              }
            },
            child: Stack(
              children: _animatedWidgetList,
            ),
          ),
        ),
        const SizedBox(height: 8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _dots,
        ),
      ],
    );
  }

}
