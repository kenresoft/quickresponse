import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/settings/date_time_format.dart';

class RealTimeWidget extends StatefulWidget {
  final TimeFormatOption selectedTimeFormat;
  final String selectedTimeSeparator;
  final TextStyle style;

  const RealTimeWidget({
    super.key,
    required this.selectedTimeFormat,
    required this.selectedTimeSeparator,
    required this.style,
  });

  @override
  State<RealTimeWidget> createState() => _RealTimeWidgetState();
}

class _RealTimeWidgetState extends State<RealTimeWidget> {
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
        // Rebuild the widget every second to update the time
        setState(() => _timeFormatter = _getTimeFormatter());
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
