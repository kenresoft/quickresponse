import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/settings/date_format.dart';

class RealTimeTimeWidget extends StatefulWidget {
  final TimeFormatOption selectedTimeFormat;
  final String selectedTimeSeparator;
  final TextStyle style;

  const RealTimeTimeWidget({
    Key? key,
    required this.selectedTimeFormat,
    required this.selectedTimeSeparator,
    required this.style,
  }) : super(key: key);

  @override
  State<RealTimeTimeWidget> createState() => _RealTimeTimeWidgetState();
}

class _RealTimeTimeWidgetState extends State<RealTimeTimeWidget> {
  late DateFormat _timeFormatter;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timeFormatter = _getTimeFormatter();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          // Rebuild the widget every second to update the time
          _timeFormatter = _getTimeFormatter();
        });
      }
    });
  }

  DateFormat _getTimeFormatter() {
    switch (widget.selectedTimeFormat) {
      case TimeFormatOption.format12Hours:
        return DateFormat('hh${widget.selectedTimeSeparator}mm${widget.selectedTimeSeparator}ss a');
      case TimeFormatOption.format24Hours:
        return DateFormat('HH${widget.selectedTimeSeparator}mm${widget.selectedTimeSeparator}ss');
      default:
        throw ArgumentError('Invalid time format');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentTime = DateTime.now();
    final formattedTime = _timeFormatter.format(currentTime);

    return Text('Current Time: $formattedTime', style: widget.style);
  }
}
