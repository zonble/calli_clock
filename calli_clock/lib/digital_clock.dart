// Copyright 2019 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';

import 'package:digital_clock/zonble_numbers_icons.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum _Element {
  background,
  icon,
}

final _lightTheme = {
  _Element.background: Colors.white,
  _Element.icon: Colors.black,
};

final _darkTheme = {
  _Element.background: Colors.black,
  _Element.icon: Colors.white,
};

List<Widget> _iconsFromString(String s, iconSize, Color color) => s
    .split('')
    .map((x) => _iconFromString(x))
    .where((x) => x != null)
    .map((x) => Icon(
          x,
          size: iconSize,
          color: color,
        ))
    .toList();

IconData _iconFromString(String s) {
  switch (s) {
    case "0":
      return ZonbleNumbers.zero;
    case "1":
      return ZonbleNumbers.one;
    case "2":
      return ZonbleNumbers.two;
    case "3":
      return ZonbleNumbers.three;
    case "4":
      return ZonbleNumbers.four;
    case "5":
      return ZonbleNumbers.five;
    case "6":
      return ZonbleNumbers.six;
    case "7":
      return ZonbleNumbers.seven;
    case "8":
      return ZonbleNumbers.eight;
    case "9":
      return ZonbleNumbers.nine;
    default:
      break;
  }
  return null;
}

/// A basic digital clock.
///
/// You can do better than this!
class DigitalClock extends StatefulWidget {
  const DigitalClock(this.model);

  final ClockModel model;

  @override
  _DigitalClockState createState() => _DigitalClockState();
}

class _DigitalClockState extends State<DigitalClock> {
  DateTime _dateTime = DateTime.now();
  Timer _timer;

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    _updateTime();
    _updateModel();
  }

  @override
  void didUpdateWidget(DigitalClock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.model != oldWidget.model) {
      oldWidget.model.removeListener(_updateModel);
      widget.model.addListener(_updateModel);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    widget.model.dispose();
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      // Cause the clock to rebuild when the model changes.
    });
  }

  void _updateTime() {
    setState(() {
      _dateTime = DateTime.now();
      // Update once per minute. If you want to update every second, use the
      // following code.
      _timer = Timer(
        Duration(minutes: 1) -
            Duration(seconds: _dateTime.second) -
            Duration(milliseconds: _dateTime.millisecond),
        _updateTime,
      );
      // Update once per second, but make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      // _timer = Timer(
      //   Duration(seconds: 1) - Duration(milliseconds: _dateTime.millisecond),
      //   _updateTime,
      // );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).brightness == Brightness.light
        ? _lightTheme
        : _darkTheme;
    final hour =
        DateFormat(widget.model.is24HourFormat ? 'HH' : 'hh').format(_dateTime);
    final minute = DateFormat('mm').format(_dateTime);

    return LayoutBuilder(builder: (context, constraints) {
      final iconSize = (constraints.maxWidth - 60) / 4.0;
      final icons =
          _iconsFromString(hour + minute, iconSize, colors[_Element.icon]);
      return Container(
        color: colors[_Element.background],
        child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center, children: icons)),
      );
    });
  }
}
