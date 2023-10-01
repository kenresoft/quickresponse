import 'package:flutter/material.dart';

import '../../main.dart';
import '../../providers/providers.dart';

part '../../utils/app_color.dart';

part '../../utils/density.dart';

var isDarkTheme = providerContainer.read(themeProvider);

var appColor = AppColor._();
